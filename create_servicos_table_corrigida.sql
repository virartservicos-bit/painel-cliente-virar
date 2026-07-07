-- Criar tabela de serviços (separada)
CREATE TABLE servicos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE,
    descricao TEXT,
    categoria VARCHAR(100),
    preco DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Ativo',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir dados de exemplo
INSERT INTO servicos (nome, descricao, categoria, preco, status) VALUES
(
    'Sepultamento',
    'Serviço completo de sepultamento com túmulo e cerimônia.',
    'Funeral',
    1800.00,
    'Ativo'
),
(
    'Cremação',
    'Serviço de cremação com cerimônia completa e acompanhamento familiar.',
    'Funeral',
    2500.00,
    'Ativo'
),
(
    'Velório',
    'Espaço digno para velório com estrutura completa para recepcionar familiares e amigos.',
    'Cerimônia',
    800.00,
    'Ativo'
),
(
    'Translado Nacional',
    'Transporte do corpo entre cidades diferentes do território nacional.',
    'Logística',
    1200.00,
    'Ativo'
),
(
    'Repatriação Internacional',
    'Serviço especializado de repatriação de corpos para outros países.',
    'Logística',
    5000.00,
    'Em Pausa'
),
(
    'Acompanhamento Familiar',
    'Suporte emocional e logístico para a família durante todo o processo.',
    'Apoio',
    500.00,
    'Ativo'
),
(
    'Documentação',
    'Auxílio completo com toda a documentação necessária para o funeral.',
    'Documentação',
    300.00,
    'Ativo'
),
(
    'Flores e Coroas',
    'Arranjos florais e coroas para homenagem e decoração.',
    'Decoracao',
    200.00,
    'Ativo'
),
(
    'Livro de Condolências',
    'Livro físico para registro de mensagens de condolências.',
    'Memorial',
    150.00,
    'Ativo'
),
(
    'Serviço de Thanatopraxia',
    'Preparação e conservação do corpo para velório e cerimônia.',
    'Preparacao',
    800.00,
    'Ativo'
);

-- Criar índices para melhor performance
CREATE INDEX idx_servicos_categoria ON servicos(categoria);
CREATE INDEX idx_servicos_status ON servicos(status);
CREATE INDEX idx_servicos_nome ON servicos(nome);

-- Habilitar RLS (Row Level Security)
ALTER TABLE servicos ENABLE ROW LEVEL SECURITY;

-- Criar políticas de acesso
CREATE POLICY "Usuários autenticados podem visualizar serviços" ON servicos
FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins podem inserir serviços" ON servicos
FOR INSERT WITH CHECK (
    auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Admins podem atualizar serviços" ON servicos
FOR UPDATE USING (
    auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Admins podem deletar serviços" ON servicos
FOR DELETE USING (
    auth.jwt() ->> 'role' = 'admin'
);
