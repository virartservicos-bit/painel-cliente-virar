# VIRAR Admin Panel

## Deploy na Vercel

Este projeto está configurado para deploy automático na Vercel.

### Configurações Aplicadas:

1. **vercel.json** - Configuração de build e variáveis de ambiente
2. **_redirects** - Garante que as rotas do React funcionem
3. **Estilos CSS com !important** - Garante que as cores sejam aplicadas na Vercel
4. **Componente PlanosPage** - Corrigido o erro de componente não definido

### Passos para Deploy:

1. Enviar o código para o GitHub
2. Conectar o repositório na Vercel
3. Configurar as variáveis de ambiente (se necessário):
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### Solução de Problemas:

Se a tela aparecer marrom escuro na Vercel:
- As cores CSS foram reforçadas com `!important`
- O Tailwind CSS está configurado via CDN
- As variáveis de ambiente têm fallbacks

### Build Local:

```bash
npm run build
npm run preview
```

O projeto está pronto para deploy na Vercel!
