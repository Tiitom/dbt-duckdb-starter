with sites as (

  select * from {{ ref('stg_sites') }}

)

, final as (

  select
    'SITE-' || site_id as site_id
    , siteName
    , countryCode
    , country_name
  from sites

)

select * from final
