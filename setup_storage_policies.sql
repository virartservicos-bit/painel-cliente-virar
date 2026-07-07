-- Criar políticas de acesso para o bucket de imagens de funerárias

-- Política para permitir uploads públicos
CREATE POLICY "Allow image uploads" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'funerarias-images'
);

-- Política para permitir leitura pública das imagens
CREATE POLICY "Allow public read access" ON storage.objects
FOR SELECT USING (
  bucket_id = 'funerarias-images'
);

-- Política para permitir atualizações (se necessário)
CREATE POLICY "Allow image updates" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'funerarias-images'
);

-- Política para permitir deleções (se necessário)
CREATE POLICY "Allow image deletions" ON storage.objects
FOR DELETE USING (
  bucket_id = 'funerarias-images'
);
