import React, { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://ikahdkaccmpldstbcbpk.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrYWhka2FjY21wbGRzdGJjYnBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2ODgyMTEsImV4cCI6MjA4OTI2NDIxMX0.C1CBpGFAHobaEiaeABrJQNOjjrXsxR0AMgyViPR39gw'
const supabase = createClient(supabaseUrl, supabaseKey)

function App() {
  const [loading, setLoading] = useState(true)
  const [user, setUser] = useState(null)

  useEffect(() => {
    console.log('=== APP.JSX INICIADO ===')
    
    supabase.auth.getSession().then(({ data: { session } }) => {
      console.log('Sessão no App.jsx:', session)
      console.log('Usuário:', session?.user?.email)
      
      if (session?.user) {
        console.log('✓ Usuário autenticado, redirecionando para funcional.html')
        window.location.href = 'funcional.html'
      } else {
        console.log('✗ Sem sessão, redirecionando para login')
        window.location.href = 'login.html'
      }
      setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      console.log('Auth change no App.jsx:', event, session?.user?.email)
      if (session?.user) {
        window.location.href = 'funcional.html'
      }
    })

    return () => subscription.unsubscribe()
  }, [])

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    window.location.href = '/login.html'
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-surface text-on-surface flex items-center justify-center">
        <div className="text-center">
          <p className="text-lg text-on-surface-variant">Carregando...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-surface text-on-surface">
      <div className="container mx-auto px-4 py-8">
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-4xl font-bold text-primary mb-2">VIRAR Parceiros</h1>
            <p className="text-lg text-on-surface-variant">Painel Administrativo do Cliente</p>
          </div>
          <button
            onClick={handleSignOut}
            className="bg-primary text-on-primary px-6 py-2 rounded-md hover:brightness-110 transition-all"
          >
            Sair
          </button>
        </div>
        
        <div className="bg-surface-container-low p-8 rounded-lg">
          <h2 className="text-2xl font-bold text-primary mb-4">Bem-vindo!</h2>
          <p className="text-on-surface-variant mb-4">Email: {user?.email}</p>
          <p className="text-on-surface-variant">
            Este é o painel administrativo do cliente. Em breve teremos mais funcionalidades aqui.
          </p>
        </div>
      </div>
    </div>
  )
}

export default App