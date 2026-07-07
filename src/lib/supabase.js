import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://ikahdkaccmpldstbcbpk.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrYWhka2FjY21wbGRzdGJjYnBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2ODgyMTEsImV4cCI6MjA4OTI2NDIxMX0.C1CBpGFAHobaEiaeABrJQNOjjrXsxR0AMgyViPR39gw'

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true
  }
})
