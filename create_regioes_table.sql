-- Criar tabela de regiões
CREATE TABLE IF NOT EXISTS regioes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('estado', 'cidade', 'bairro')),
    parent_id UUID REFERENCES regioes(id) ON DELETE CASCADE,
    estado VARCHAR(2), -- Sigla do estado para regiões tipo cidade/bairro
    codigo_ibge VARCHAR(20), -- Código IBGE para integração
    status VARCHAR(50) DEFAULT 'ativo' CHECK (status IN ('ativo', 'inativo', 'em_expansao')),
    parceiros_count INTEGER DEFAULT 0, -- Contador de funerárias parceiras
    densidade VARCHAR(20) DEFAULT 'baixa', -- baixa, media, alta
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para performance
CREATE INDEX idx_regioes_tipo ON regioes(tipo);
CREATE INDEX idx_regioes_parent_id ON regioes(parent_id);
CREATE INDEX idx_regioes_estado ON regioes(estado);
CREATE INDEX idx_regioes_status ON regioes(status);

-- Inserir dados iniciais (estados brasileiros)
INSERT INTO regioes (nome, tipo, estado, status, parceiros_count) VALUES
('São Paulo', 'estado', 'SP', 'ativo', 342),
('Rio de Janeiro', 'estado', 'RJ', 'ativo', 184),
('Minas Gerais', 'estado', 'MG', 'em_expansao', 4),
('Bahia', 'estado', 'BA', 'ativo', 89),
('Paraná', 'estado', 'PR', 'ativo', 156),
('Rio Grande do Sul', 'estado', 'RS', 'ativo', 134),
('Pernambuco', 'estado', 'PE', 'em_expansao', 12),
('Ceará', 'estado', 'CE', 'ativo', 78),
('Goiás', 'estado', 'GO', 'em_expansao', 23),
('Santa Catarina', 'estado', 'SC', 'ativo', 98),
('Distrito Federal', 'estado', 'DF', 'ativo', 45),
('Espírito Santo', 'estado', 'ES', 'ativo', 67);

-- Inserir algumas cidades de exemplo
INSERT INTO regioes (nome, tipo, parent_id, estado, status, parceiros_count) VALUES
('São Paulo', 'cidade', (SELECT id FROM regioes WHERE nome = 'São Paulo' AND tipo = 'estado'), 'SP', 'ativo', 128),
('Guarulhos', 'cidade', (SELECT id FROM regioes WHERE nome = 'São Paulo' AND tipo = 'estado'), 'SP', 'ativo', 34),
('Campinas', 'cidade', (SELECT id FROM regioes WHERE nome = 'São Paulo' AND tipo = 'estado'), 'SP', 'ativo', 28),
('Rio de Janeiro', 'cidade', (SELECT id FROM regioes WHERE nome = 'Rio de Janeiro' AND tipo = 'estado'), 'RJ', 'ativo', 89),
('Niterói', 'cidade', (SELECT id FROM regioes WHERE nome = 'Rio de Janeiro' AND tipo = 'estado'), 'RJ', 'ativo', 23),
('Belo Horizonte', 'cidade', (SELECT id FROM regioes WHERE nome = 'Minas Gerais' AND tipo = 'estado'), 'MG', 'em_expansao', 4);

-- Inserir alguns bairros de exemplo
INSERT INTO regioes (nome, tipo, parent_id, estado, status, parceiros_count) VALUES
('Vila Mariana', 'bairro', (SELECT id FROM regioes WHERE nome = 'São Paulo' AND tipo = 'cidade'), 'SP', 'ativo', 12),
('Jardins', 'bairro', (SELECT id FROM regioes WHERE nome = 'São Paulo' AND tipo = 'cidade'), 'SP', 'ativo', 8),
('Copacabana', 'bairro', (SELECT id FROM regioes WHERE nome = 'Rio de Janeiro' AND tipo = 'cidade'), 'RJ', 'ativo', 15),
('Ipanema', 'bairro', (SELECT id FROM regioes WHERE nome = 'Rio de Janeiro' AND tipo = 'cidade'), 'RJ', 'ativo', 11);

-- Habilitar RLS (Row Level Security)
ALTER TABLE regioes ENABLE ROW LEVEL SECURITY;

-- Política simplificada - permite qualquer usuário autenticado (temporarily)
CREATE POLICY "Usuários autenticados podem gerenciar regiões" ON regioes
    FOR ALL USING (auth.role() = 'authenticated');

-- Política para usuários autenticados lerem regiões
CREATE POLICY "Usuários autenticados podem ver regiões" ON regioes
    FOR SELECT USING (auth.role() = 'authenticated');

-- Função para atualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para atualizar updated_at
CREATE TRIGGER update_regioes_updated_at 
    BEFORE UPDATE ON regioes 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
