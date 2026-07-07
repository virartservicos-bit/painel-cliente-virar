-- Criar tabela de serviços
CREATE TABLE servicos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100),
    preco DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Ativo',
    
    -- Relacionamento com funerárias (muitos para muitos)
    funerarias_associadas INTEGER DEFAULT 0,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir dados de exemplo
INSERT INTO servicos (nome, descricao, categoria, preco, status, funerarias_associadas) VALUES
(
    'Cremação Premium',
    'Serviço de cremação com cerimônia completa e acompanhamento familiar.',
    'Funeral',
    2500.00,
    'Ativo',
    12
),
(
    'Velório Cerimonial',
    'Espaço digno para velório com estrutura completa para recepcionar familiares e amigos.',
    'Cerimônia',
    800.00,
    'Ativo',
    18
),
(
    'Repatriação Internacional',
    'Serviço especializado de repatriação de corpos para outros países.',
    'Logística',
    5000.00,
    'Em Pausa',
    5
),
(
    'Sepultamento Tradicional',
    'Serviço completo de sepultamento com túmulo e cerimônia.',
    'Funeral',
    1800.00,
    'Ativo',
    15
),
(
    'Translado Nacional',
    'Transporte do corpo entre cidades diferentes do território nacional.',
    'Logística',
    1200.00,
    'Ativo',
    8
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
