-- Desabilitar RLS para a tabela profiles
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Ou criar política para admin ver todos os usuários
CREATE POLICY "Admins can view all profiles" ON profiles
FOR SELECT USING (
  auth.jwt() ->> 'role' = 'admin' OR 
  auth.uid() IS NOT NULL
);

-- Política para admin inserir usuários
CREATE POLICY "Admins can insert profiles" ON profiles
FOR INSERT WITH CHECK (
  auth.jwt() ->> 'role' = 'admin'
);

-- Política para admin atualizar usuários
CREATE POLICY "Admins can update profiles" ON profiles
FOR UPDATE USING (
  auth.jwt() ->> 'role' = 'admin'
);

-- Política para admin deletar usuários
CREATE POLICY "Admins can delete profiles" ON profiles
FOR DELETE USING (
  auth.jwt() ->> 'role' = 'admin'
);

-- Reabilitar RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
