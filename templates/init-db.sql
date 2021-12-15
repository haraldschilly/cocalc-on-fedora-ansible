INSERT INTO public.server_settings ("name", "value") VALUES
	 ('iframe_comm_hosts','{{cocalc_iframe_comm_hosts}}'),
	 ('site_name', '{{cocalc_site_name}}'),
	 ('site_description','{{cocalc_site_description}}'),
	 ('help_email','{{cocalc_admin_email}}'),
	 ('email_signup','no'),
	 ('dns','{{cocalc_dns}}')
ON CONFLICT (name) DO UPDATE SET value=EXCLUDED.value;


INSERT INTO public.accounts (
    account_id, 
    creation_actions_done, 
    password_hash, 
    "name", 
    email_address,
    first_name,
    last_name,
    "groups",
    api_key) 
VALUES
	 ('11111111-2222-3333-4444-555555555555'::uuid,
     true, 
     'sha512$30ce50d10394f0b7662ccf73704ab518$1000$b2de838eb6b5aea97cdaa1e81f17368bc91c55f871cdf3d39517fe22e9e24965966d190254c892c66455182cb6e89419b3393a818a6bfdee32c40eccf1ac4391',
     'admin',
     '{{cocalc_admin_email}}',
     '{{cocalc_admin_first_name}}','{{cocalc_admin_last_name}}','{"admin"}', 
     'sk_T9vkW3aSJF4qSU6QgEarQ62w')
 ON CONFLICT DO NOTHING;


 INSERT INTO public.registration_tokens ("token",descr,counter,expires,"limit",disabled) VALUES
	 ('KJ7b26Mh314msDZi','for Students',1.0,NULL,50.0,false)
     ON CONFLICT DO NOTHING;
