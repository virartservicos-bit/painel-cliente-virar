-- Adicionar campo is_admin para identificar administradores deste sistema
ALTER TABLE public.profiles 
ADD COLUMN is_admin boolean NOT NULL DEFAULT false;

-- Criar índice para o novo campo
CREATE INDEX IF NOT EXISTS profiles_is_admin_idx ON public.profiles USING btree (is_admin) TABLESPACE pg_default;

-- Adicionar comentário para documentar o propósito do campo
COMMENT ON COLUMN public.profiles.is_admin IS 'Indica se usuário é administrador deste painel: true (administrador), false (usuário comum)';

-- Exemplo de como criar um usuário administrador:
-- UPDATE public.profiles SET is_admin = true WHERE email = 'admin@exemplo.com';
