-- ============================================================================
-- SCRIPT COMPLETO: Corrigir Cadastro + Sistema de Códigos de Parceiros
-- ============================================================================

-- PARTE 1: Corrigir problema de cadastro (RLS Policies)
-- ============================================================================

-- 1. Garante que os campos existem na tabela profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_client boolean NOT NULL DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_admin boolean NOT NULL DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS profile_type text NOT NULL DEFAULT 'citizen'::text;

-- 2. Adicionar campo para rastrear quem indicou este cliente
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS referred_by_code text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS referred_at timestamp with time zone;

-- 3. Habilita RLS na tabela (boa prática de segurança)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 4. Policy: Permite a leitura do próprio perfil
DROP POLICY IF EXISTS "Permitir usuário ver o próprio perfil" ON public.profiles;
CREATE POLICY "Permitir usuário ver o próprio perfil"
ON public.profiles FOR SELECT
USING (auth.uid() = id);

-- 5. Policy: Permite INSERIR (criar) o próprio perfil no momento do cadastro
DROP POLICY IF EXISTS "Permitir usuário inserir o próprio perfil" ON public.profiles;
CREATE POLICY "Permitir usuário inserir o próprio perfil"
ON public.profiles FOR INSERT
WITH CHECK (auth.uid() = id);

-- 6. Policy: Permite ATUALIZAR (upsert) o próprio perfil
DROP POLICY IF EXISTS "Permitir usuário atualizar o próprio perfil" ON public.profiles;
CREATE POLICY "Permitir usuário atualizar o próprio perfil"
ON public.profiles FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);


-- PARTE 2: Sistema de Códigos de Parceiros
-- ============================================================================

-- 7. Criar tabela de parceiros (funcionários/embaixadores)
CREATE TABLE IF NOT EXISTS public.partners (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    partner_code text UNIQUE NOT NULL,
    partner_name text NOT NULL,
    partner_type text NOT NULL DEFAULT 'employee', -- employee, ambassador, partner
    is_active boolean NOT NULL DEFAULT true,
    commission_rate decimal(5,2) DEFAULT 0.00,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 8. Criar índice para busca rápida por código
CREATE INDEX IF NOT EXISTS idx_partners_code ON public.partners(partner_code);
CREATE INDEX IF NOT EXISTS idx_partners_active ON public.partners(is_active);

-- 9. Habilitar RLS na tabela de parceiros
ALTER TABLE public.partners ENABLE ROW LEVEL SECURITY;

-- 10. Policy: Todos podem ler parceiros ativos (para validar código no cadastro)
DROP POLICY IF EXISTS "Permitir leitura de parceiros ativos" ON public.partners;
CREATE POLICY "Permitir leitura de parceiros ativos"
ON public.partners FOR SELECT
USING (is_active = true);

-- 11. Policy: Apenas admins podem inserir/atualizar parceiros (você pode ajustar depois)
DROP POLICY IF EXISTS "Apenas admins podem gerenciar parceiros" ON public.partners;
CREATE POLICY "Apenas admins podem gerenciar parceiros"
ON public.partners FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
);

-- 12. Criar view para relatório de indicações por parceiro
CREATE OR REPLACE VIEW public.partner_referrals AS
SELECT 
    p.partner_code,
    p.partner_name,
    p.partner_type,
    COUNT(pr.id) as total_referrals,
    COUNT(CASE WHEN pr.referred_at >= NOW() - INTERVAL '6 months' THEN 1 END) as referrals_last_6_months,
    MIN(pr.referred_at) as first_referral,
    MAX(pr.referred_at) as last_referral
FROM public.partners p
LEFT JOIN public.profiles pr ON pr.referred_by_code = p.partner_code
WHERE p.is_active = true
GROUP BY p.partner_code, p.partner_name, p.partner_type;

-- 13. Inserir alguns parceiros de exemplo (OPCIONAL - remova se não quiser)
INSERT INTO public.partners (partner_code, partner_name, partner_type, commission_rate)
VALUES 
    ('JOAO15', 'João Silva', 'employee', 10.00),
    ('MARIA20', 'Maria Santos', 'ambassador', 8.00),
    ('PEDRO10', 'Pedro Costa', 'partner', 12.00)
ON CONFLICT (partner_code) DO NOTHING;

-- ============================================================================
-- FIM DO SCRIPT
-- Execute este script completo no SQL Editor do Supabase
-- ============================================================================
