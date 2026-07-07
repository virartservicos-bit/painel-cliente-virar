-- Criar políticas de acesso para o bucket "images"

-- Política para permitir uploads de imagens
CREATE POLICY "Allow image uploads" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'images'
);

-- Política para permitir leitura pública das imagens
CREATE POLICY "Allow public read access" ON storage.objects
FOR SELECT USING (
  bucket_id = 'images'
);

-- Política para permitir atualizações de imagens
CREATE POLICY "Allow image updates" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'images'
);

-- Política para permitir deleções de imagens
CREATE POLICY "Allow image deletions" ON storage.objects
FOR DELETE USING (
  bucket_id = 'images'
);
