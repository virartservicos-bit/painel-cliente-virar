-- Criar tabela de funerárias
CREATE TABLE funerarias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    
    -- Contato
    telefone VARCHAR(20),
    email VARCHAR(255),
    site VARCHAR(255),
    
    -- Endereço
    rua_avenida VARCHAR(255) NOT NULL,
    numero VARCHAR(20),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    
    -- Horário de Funcionamento
    dias_semana VARCHAR(100),
    horario_abertura TIME,
    horario_fechamento TIME,
    
    -- Serviços
    servicos TEXT[],
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir dados de exemplo
INSERT INTO funerarias (nome, descricao, telefone, email, site, rua_avenida, numero, bairro, cidade, estado, dias_semana, horario_abertura, horario_fechamento, servicos) VALUES
(
    'Funerária Paz Eterna',
    'Atendimento humanizado e completo para todas as necessidades funerárias. Mais de 30 anos de experiência no mercado.',
    '(11) 3456-7890',
    'contato@pazeterna.com.br',
    'www.pazeterna.com.br',
    'Rua das Flores',
    '123',
    'Centro',
    'São Paulo',
    'SP',
    'Segunda a Sábado',
    '08:00:00',
    '18:00:00',
    ARRAY['Sepultamento', 'Cremação', 'Velório', 'Translado', 'Assistência Funeral 24h', 'Funerais Personalizados']
),
(
    'Funerária Consolação',
    'Serviços funerários com respeito e dignidade. Equipe preparada para atender famílias em momento difícil.',
    '(21) 2345-6789',
    'atendimento@consolacao.funeraria',
    'www.consolacaofuneraria.com.br',
    'Avenida Brasil',
    '456',
    'Botafogo',
    'Rio de Janeiro',
    'RJ',
    'Todos os dias',
    '00:00:00',
    '23:59:59',
    ARRAY['Cremação', 'Sepultamento', 'Velório Capela', 'Orquidário', 'Serviço de Thanatopraxia', 'Documentação']
),
(
    'Agência Funerária Esperança',
    'Tradição e confiança em serviços funerários. Atendimento 24 horas em toda a região metropolitana.',
    '(31) 3456-1234',
    'esperanca@funerariaesperanca.com',
    'www.funerariaesperanca.com',
    'Rua da Saudade',
    '789',
    'Santo Antônio',
    'Belo Horizonte',
    'MG',
    'Segunda a Domingo',
    '07:00:00',
    '20:00:00',
    ARRAY['Funerais', 'Cremações', 'Translado Nacional', 'Capela Mortuária', 'Flores e Coroas', 'Serviços de Umbanda']
),
(
    'Funerária Luz Divina',
    'Cuidado e compaixão em cada detalhe. Serviços completos com infraestrutura moderna.',
    '(51) 3234-5678',
    'contato@luzdivina.funeraria',
    'www.luzdivinafuneraria.com.br',
    'Avenida Borges de Medeiros',
    '321',
    'Centro Histórico',
    'Porto Alegre',
    'RS',
    'Segunda a Sábado',
    '08:30:00',
    '17:30:00',
    ARRAY['Sepultamento', 'Cremação', 'Velório', 'Acompanhamento Familiar', 'Serviço Social', 'Preparação do Corpo']
),
(
    'Memorial Funerária',
    'Excelência em serviços funerários com 50 anos de tradição. Atendimento diferenciado para todas as religiões.',
    '(81) 3322-4455',
    'faleconosco@memorialfuneraria.com',
    'www.memorialfuneraria.com.br',
    'Rua da Aurora',
    '654',
    'Boa Vista',
    'Recife',
    'PE',
    'Segunda a Sábado',
    '08:00:00',
    '19:00:00',
    ARRAY['Funerais Católicos', 'Funerais Evangélicos', 'Cremação', 'Sepultamento', 'Capelas', 'Serviço de Coroação']
);

-- Criar índices para melhor performance
CREATE INDEX idx_funerarias_cidade ON funerarias(cidade);
CREATE INDEX idx_funerarias_estado ON funerarias(estado);
CREATE INDEX idx_funerarias_nome ON funerarias(nome);

-- Habilitar RLS (Row Level Security)
ALTER TABLE funerarias ENABLE ROW LEVEL SECURITY;

-- Criar políticas de acesso
CREATE POLICY "Usuários autenticados podem visualizar funerárias" ON funerarias
FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins podem inserir funerárias" ON funerarias
FOR INSERT WITH CHECK (
    auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Admins podem atualizar funerárias" ON funerarias
FOR UPDATE USING (
    auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Admins podem deletar funerárias" ON funerarias
FOR DELETE USING (
    auth.jwt() ->> 'role' = 'admin'
);
