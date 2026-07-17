with matching_patient as (
    select 
        patient_id      as patient_id
    , trial_id          as trial_id
    , site_id           as site_id
    , processedAt       as processed_at
    , reviewedAt        as reviewed_at
    , enrolledAt        as enrolled_at
    from 
{{ ref('fct_patient_trial_matches') }}
),
sites as (
    select 
        site_id             as site_id
        , country_name      as country_name
    from {{ ref('dim_sites') }}
),
sponsors as (
    select
        sponsor_id          as sponsor_id
    , sponsor_name      as sponsor_name
    from {{ ref('dim_sponsors') }}
),
trials as (
    select
    trial_id           as trial_id
    , sponsor_id       as sponsor_id
    , trialName        as trial_name
    from {{ ref('dim_trials') }}
),
final as (
    select
    mp.patient_id
    , mp.trial_id
    , mp.site_id
    , case when mp.processed_at is not null then 'Yes' else 'No' end as is_processed_label
    , case when mp.processed_at is not null then 1 else 0 end as is_processed_in
    , case when mp.reviewed_at is not null then 'Yes' else 'No' end as is_reviewed_label
    , case when mp.reviewed_at is not null then 1 else 0 end as is_reviewed_in
    , case when mp.enrolled_at is not null then 'Yes' else 'No' end as is_enrolled_label
    , case when mp.enrolled_at is not null then 1 else 0 end as is_enrolled_in
    , s.country_name
    , t.trial_name
    , sp.sponsor_name
    from matching_patient mp
    left join sites s on mp.site_id = s.site_id
    left join trials t on mp.trial_id = t.trial_id
    left join sponsors sp on t.sponsor_id = sp.sponsor_id
)
select 
    * 
from final
where sponsor_name = 'Sanofi'