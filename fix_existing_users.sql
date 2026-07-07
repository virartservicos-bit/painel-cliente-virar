-- ============================================================================
-- Script para corrigir usuários existentes que não conseguem fazer login
-- ============================================================================

-- 1. Ver todos os usuários que NÃO são clientes ou não têm profile
SELECT 
    au.id,
    au.email,
    au.created_at as user_created,
    p.is_client,
    p.is_admin,
    p.profile_type
FROM auth.users au
LEFT JOIN public.profiles p ON p.id = au.id
WHERE p.is_client IS NULL OR p.is_client = false
ORDER BY au.created_at DESC;

-- 2. ATUALIZAR todos os usuários existentes para serem clientes
-- Execute este comando para marcar TODOS os usuários como clientes
UPDATE public.profiles
SET 
    is_client = true,
    profile_type = 'client'
WHERE is_client = false OR is_client IS NULL;

-- 3. CRIAR profiles para usuários que não têm (caso existam)
-- Este comando cria profiles para usuários que foram cadastrados mas não têm profile
INSERT INTO public.profiles (id, email, is_client, is_admin, profile_type)
SELECT 
    au.id,
    au.email,
    true as is_client,
    false as is_admin,
    'client' as profile_type
FROM auth.users au
LEFT JOIN public.profiles p ON p.id = au.id
WHERE p.id IS NULL
ON CONFLICT (id) DO NOTHING;

-- 4. Verificar resultado - todos devem estar como is_client = true
SELECT 
    au.email,
    p.is_client,
    p.is_admin,
    p.profile_type,
    p.referred_by_code
FROM auth.users au
JOIN public.profiles p ON p.id = au.id
ORDER BY au.created_at DESC;

-- ============================================================================
-- INSTRUÇÕES:
-- 1. Execute o comando #1 primeiro para ver quais usuários têm problema
-- 2. Execute o comando #2 para marcar todos como clientes
-- 3. Execute o comando #3 para criar profiles faltantes
-- 4. Execute o comando #4 para confirmar que todos estão corretos
-- ============================================================================
