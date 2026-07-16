-- Tabela empresas para armazenar dados de cadastro de clientes
create table public.empresas (
  id uuid not null default gen_random_uuid(),
  user_id uuid not null,
  razao_social text not null,
  nome_fantasia text null,
  cnpj text not null,
  data_fundacao date null,
  responsavel_nome text not null,
  responsavel_cpf text not null,
  responsavel_cargo text null,
  responsavel_telefone text not null,
  responsavel_email text not null,
  endereco_cep text null,
  endereco_rua text null,
  endereco_numero text null,
  endereco_complemento text null,
  endereco_bairro text null,
  endereco_cidade text null,
  endereco_estado text null,
  segmento text null,
  funcionarios text null,
  site text null,
  redes_sociais text null,
  descricao text null,
  doc_cnpj text null,
  doc_identidade text null,
  doc_endereco text null,
  doc_contrato text null,
  status text not null default 'pendente',
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  constraint empresas_pkey primary key (id),
  constraint empresas_user_id_fkey foreign key (user_id) references auth.users (id) on delete cascade,
  constraint empresas_user_id_key unique (user_id)
) TABLESPACE pg_default;

-- Índices
create index IF not exists empresas_user_id_idx on public.empresas using btree (user_id) TABLESPACE pg_default;
create index IF not exists empresas_cnpj_idx on public.empresas using btree (cnpj) TABLESPACE pg_default;
create index IF not exists empresas_status_idx on public.empresas using btree (status) TABLESPACE pg_default;

-- Trigger para atualizar updated_at
create trigger update_empresas_updated_at BEFORE
update on empresas for EACH row
execute FUNCTION update_updated_at_column ();

-- Row Level Security (RLS)
alter table public.empresas enable row level security;

-- Policy: Usuários podem ver apenas seus próprios dados
create policy "Usuários podem ver suas próprias empresas"
  on public.empresas for select
  using (auth.uid() = user_id);

-- Policy: Usuários podem inserir seus próprios dados
create policy "Usuários podem inserir suas próprias empresas"
  on public.empresas for insert
  with check (auth.uid() = user_id);

-- Policy: Usuários podem atualizar seus próprios dados
create policy "Usuários podem atualizar suas próprias empresas"
  on public.empresas for update
  using (auth.uid() = user_id);

-- Policy: Admins podem ver todas as empresas
create policy "Admins podem ver todas as empresas"
  on public.empresas for select
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.is_admin = true
    )
  );

-- Policy: Admins podem atualizar status de empresas
create policy "Admins podem atualizar empresas"
  on public.empresas for update
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.is_admin = true
    )
  );
