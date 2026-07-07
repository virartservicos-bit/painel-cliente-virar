-- Adicionar campo is_client para identificar clientes do sistema
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS is_client boolean NOT NULL DEFAULT false;

-- Criar índice para o novo campo
CREATE INDEX IF NOT EXISTS profiles_is_client_idx ON public.profiles USING btree (is_client) TABLESPACE pg_default;

-- Documentar o propósito do campo
COMMENT ON COLUMN public.profiles.is_client IS 'Indica se o usuário é cliente: true (cliente), false (não cliente)';
