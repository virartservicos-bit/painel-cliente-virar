<!-- Supabase Authentication Script -->
<script>
    // Configuração do Supabase
    const supabaseUrl = 'https://ikahdkaccmpldstbcbpk.supabase.co';
    const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrYWhka2FjY21wbGRzdGJjYnBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2ODgyMTEsImV4cCI6MjA4OTI2NDIxMX0.C1CBpGFAHobaEiaeABrJQNOjjrXsxR0AMgyViPR39gw';
    const supabaseClient = supabase.createClient(supabaseUrl, supabaseKey);

    // Verificar autenticação
    async function checkAuth() {
        const { data: { session } } = await supabaseClient.auth.getSession();
        if (!session?.user) {
            window.location.href = 'login.html';
            return;
        }
    }

    // Função de logout
    function logout() {
        supabaseClient.auth.signOut()
            .then(() => {
                window.location.href = 'login.html';
            })
            .catch((error) => {
                console.error('Erro ao fazer logout:', error);
            });
    }

    // Adicionar evento de logout ao perfil do usuário
    document.addEventListener('DOMContentLoaded', () => {
        checkAuth();
        const userProfile = document.querySelector('.px-8.mt-auto.pt-8.border-t');
        if (userProfile) {
            userProfile.style.cursor = 'pointer';
            userProfile.addEventListener('click', () => {
                if (confirm('Deseja sair do sistema?')) {
                    logout();
                }
            });
        }
    });
</script>
