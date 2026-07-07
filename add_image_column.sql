-- Adicionar coluna de imagem na tabela de funerárias
ALTER TABLE funerarias ADD COLUMN imagem VARCHAR(500);

-- Adicionar comentário na coluna
COMMENT ON COLUMN funerarias.imagem IS 'URL da imagem da funerária';
