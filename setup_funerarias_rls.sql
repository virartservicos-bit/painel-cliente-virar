-- ============================================================================
-- Script para configurar tabela de funerárias com filtro por usuário
-- ============================================================================

-- 1. Adicionar campo user_id na tabela funerarias se não existir
ALTER TABLE public.funerarias ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;

-- 2. Criar índice para melhorar performance de busca por usuário
CREATE INDEX IF NOT EXISTS idx_funerarias_user_id ON public.funerarias(user_id);

-- 3. Habilitar RLS na tabela funerarias
ALTER TABLE public.funerarias ENABLE ROW LEVEL SECURITY;

-- 4. Policy: Usuário só pode ver suas próprias funerárias
DROP POLICY IF EXISTS "Usuários veem apenas suas funerárias" ON public.funerarias;
CREATE POLICY "Usuários veem apenas suas funerárias"
ON public.funerarias FOR SELECT
USING (auth.uid() = user_id);

-- 5. Policy: Usuário só pode inserir funerárias para si mesmo
DROP POLICY IF EXISTS "Usuários inserem apenas suas funerárias" ON public.funerarias;
CREATE POLICY "Usuários inserem apenas suas funerárias"
ON public.funerarias FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 6. Policy: Usuário só pode atualizar suas próprias funerárias
DROP POLICY IF EXISTS "Usuários atualizam apenas suas funerárias" ON public.funerarias;
CREATE POLICY "Usuários atualizam apenas suas funerárias"
ON public.funerarias FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 7. Policy: Usuário só pode deletar suas próprias funerárias
DROP POLICY IF EXISTS "Usuários deletam apenas suas funerárias" ON public.funerarias;
CREATE POLICY "Usuários deletam apenas suas funerárias"
ON public.funerarias FOR DELETE
USING (auth.uid() = user_id);

-- ============================================================================
-- APLICAR O MESMO PARA OUTRAS TABELAS (serviços, regiões, planos, etc)
-- ============================================================================

-- SERVIÇOS
ALTER TABLE public.servicos ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_servicos_user_id ON public.servicos(user_id);
ALTER TABLE public.servicos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Usuários veem apenas seus serviços" ON public.servicos;
CREATE POLICY "Usuários veem apenas seus serviços"
ON public.servicos FOR SELECT
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuários inserem apenas seus serviços" ON public.servicos;
CREATE POLICY "Usuários inserem apenas seus serviços"
ON public.servicos FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuários atualizam apenas seus serviços" ON public.servicos;
CREATE POLICY "Usuários atualizam apenas seus serviços"
ON public.servicos FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuários deletam apenas seus serviços" ON public.servicos;
CREATE POLICY "Usuários deletam apenas seus serviços"
ON public.servicos FOR DELETE
USING (auth.uid() = user_id);

-- REGIÕES
ALTER TABLE public.regioes ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_regioes_user_id ON public.regioes(user_id);
ALTER TABLE public.regioes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Usuários veem apenas suas regiões" ON public.regioes;
CREATE POLICY "Usuários veem apenas suas regiões"
ON public.regioes FOR SELECT
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuários inserem apenas suas regiões" ON public.regioes;
CREATE POLICY "Usuários inserem apenas suas regiões"
ON public.regioes FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuários atualizam apenas suas regiões" ON public.regioes;
CREATE POLICY "Usuários atualizam apenas suas regiões"
ON public.regioes FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuários deletam apenas suas regiões" ON public.regioes;
CREATE POLICY "Usuários deletam apenas suas regiões"
ON public.regioes FOR DELETE
USING (auth.uid() = user_id);

-- ============================================================================
-- FIM DO SCRIPT
-- Execute este script completo no SQL Editor do Supabase
-- ============================================================================
