{{ config(
    tags=["six_hourly"]
) }}

{{ simple_cte([
    ('dim_crm_account','dim_crm_account'),
    ('dim_crm_opportunity','dim_crm_opportunity'),
    ('dim_sales_qualified_source','dim_sales_qualified_source'),
    ('dim_order_type','dim_order_type'),
    ('dim_deal_path','dim_deal_path'),
    ('fct_crm_opportunity','fct_crm_opportunity'), 
    ('dim_dr_partner_engagement', 'dim_dr_partner_engagement'),
    ('dim_alliance_type', 'dim_alliance_type_scd'),
    ('dim_channel_type', 'dim_channel_type'),
    ('dim_date', 'dim_date'),
    ('dim_crm_user_hierarchy', 'dim_crm_user_hierarchy'),
    ('dim_crm_user', 'dim_crm_user')
]) }},

final AS (

  SELECT

    --primary key
    fct_crm_opportunity.dim_crm_opportunity_id,

    --surrogate keys
    dim_crm_account.dim_parent_crm_account_id,
    fct_crm_opportunity.dim_crm_user_id,
    dim_crm_opportunity.dim_parent_crm_opportunity_id,
    dim_crm_opportunity.duplicate_opportunity_id,
    dim_crm_opportunity.contract_reset_opportunity_id,
    fct_crm_opportunity.merged_crm_opportunity_id,
    fct_crm_opportunity.record_type_id,
    fct_crm_opportunity.ssp_id,
    fct_crm_opportunity.dim_crm_current_account_set_hierarchy_sk,
    dim_crm_account.dim_crm_account_id,
    
    -- opportunity attributes
    dim_crm_opportunity.opportunity_name,
    dim_crm_opportunity.stage_name,
    dim_crm_opportunity.reason_for_loss,
    dim_crm_opportunity.reason_for_loss_details,
    dim_crm_opportunity.reason_for_loss_staged,
    dim_crm_opportunity.reason_for_loss_calc,
    dim_crm_opportunity.risk_type,
    dim_crm_opportunity.risk_reasons,
    dim_crm_opportunity.downgrade_reason,
    dim_crm_opportunity.downgrade_details,
    dim_crm_opportunity.subscription_type,
    fct_crm_opportunity.closed_buckets,
    dim_crm_opportunity.opportunity_category,
    dim_crm_opportunity.source_buckets,
    dim_crm_opportunity.crm_sales_dev_rep_id,
    dim_crm_opportunity.crm_business_dev_rep_id,
    dim_crm_opportunity.opportunity_development_representative,
    dim_crm_opportunity.sdr_or_bdr,
    dim_crm_opportunity.iqm_submitted_by_role,
    dim_crm_opportunity.sdr_pipeline_contribution,
    fct_crm_opportunity.fpa_master_bookings_flag,
    dim_crm_opportunity.sales_path,
    dim_crm_opportunity.professional_services_value,
    dim_crm_opportunity.edu_services_value,
    dim_crm_opportunity.investment_services_value,
    fct_crm_opportunity.primary_solution_architect,
    fct_crm_opportunity.product_details,
    fct_crm_opportunity.product_category,
    fct_crm_opportunity.products_purchased,
    fct_crm_opportunity.growth_type,
    fct_crm_opportunity.opportunity_deal_size,
    dim_crm_opportunity.primary_campaign_source_id,
    fct_crm_opportunity.ga_client_id,
    dim_crm_opportunity.vsa_readout,
    dim_crm_opportunity.vsa_start_date,
    dim_crm_opportunity.vsa_end_date,
    dim_crm_opportunity.vsa_url,
    dim_crm_opportunity.vsa_status,
    dim_crm_opportunity.intended_product_tier,
    dim_crm_opportunity.deployment_preference,
    dim_crm_opportunity.net_new_source_categories,
    dim_crm_opportunity.invoice_number,
    dim_crm_opportunity.opportunity_term,
    dim_crm_opportunity.stage_name_3plus,
    dim_crm_opportunity.stage_name_4plus,
    dim_crm_opportunity.stage_category,
    dim_crm_opportunity.deal_category,
    dim_crm_opportunity.deal_group,
    dim_crm_opportunity.deal_size,
    dim_crm_opportunity.calculated_deal_size,
    dim_crm_opportunity.dr_partner_engagement,
    dim_crm_opportunity.deal_path_engagement,
    dim_crm_opportunity.forecast_category_name,
    dim_crm_user.user_name                                               AS opportunity_owner,
    dim_crm_opportunity.opportunity_owner_manager,
    dim_crm_opportunity.opportunity_owner_department,
    dim_crm_opportunity.opportunity_owner_role,    
    dim_crm_opportunity.opportunity_owner_title,
    dim_crm_opportunity.solutions_to_be_replaced,
    dim_crm_opportunity.opportunity_health,
    dim_crm_opportunity.tam_notes,
    dim_crm_opportunity.generated_source,
    dim_crm_opportunity.churn_contraction_type,
    dim_crm_opportunity.churn_contraction_net_arr_bucket,
    dim_crm_opportunity.dim_crm_user_id AS owner_id,
    dim_crm_opportunity.resale_partner_name,
    dim_deal_path.deal_path_name,
    dim_order_type.order_type_name                                       AS order_type,
    dim_order_type.order_type_grouped,
    dim_order_type_current.order_type_name                               AS order_type_current,
    dim_dr_partner_engagement.dr_partner_engagement_name,
    dim_alliance_type.alliance_type_name,
    dim_alliance_type.alliance_type_short_name,
    dim_channel_type.channel_type_name,
    dim_sales_qualified_source.sales_qualified_source_name,
    dim_sales_qualified_source.sales_qualified_source_grouped,
    dim_sales_qualified_source.sqs_bucket_engagement,
    dim_crm_opportunity.record_type_name,
    dim_crm_opportunity.next_steps,
    dim_crm_opportunity.auto_renewal_status,
    dim_crm_opportunity.qsr_notes,
    dim_crm_opportunity.qsr_status,
    dim_crm_opportunity.manager_confidence,
    dim_crm_opportunity.renewal_risk_category,
    dim_crm_opportunity.renewal_swing_arr,
    dim_crm_opportunity.renewal_manager, 
    dim_crm_opportunity.renewal_forecast_health,
    dim_crm_opportunity.ptc_predicted_arr,
    dim_crm_opportunity.ptc_predicted_renewal_risk_category,    
    dim_crm_opportunity.startup_type,

    -- Account fields
    dim_crm_account.crm_account_name,
    dim_crm_account.parent_crm_account_name,
    dim_crm_account.parent_crm_account_sales_segment,
    dim_crm_account.parent_crm_account_geo,
    dim_crm_account.parent_crm_account_geo_pubsec_segment,
    dim_crm_account.parent_crm_account_territory,
    dim_crm_account.parent_crm_account_region,
    dim_crm_account.parent_crm_account_area,
    dim_crm_account.parent_crm_account_business_unit,
    dim_crm_account.parent_crm_account_role_type,
    dim_crm_account.parent_crm_account_max_family_employee,
    dim_crm_account.parent_crm_account_upa_country,
    dim_crm_account.parent_crm_account_upa_state,
    dim_crm_account.parent_crm_account_upa_city,
    dim_crm_account.parent_crm_account_upa_street,
    dim_crm_account.parent_crm_account_upa_postal_code,
    dim_crm_account.owner_role                                    AS account_user_role,
    dim_crm_account.crm_account_employee_count,
    dim_crm_account.crm_account_gtm_strategy,
    dim_crm_account.crm_account_focus_account,
    dim_crm_account.crm_account_zi_technologies,
    dim_crm_account.is_jihu_account,
    dim_crm_account.admin_manual_source_number_of_employees,
    dim_crm_account.admin_manual_source_account_address,
    dim_crm_account.parent_crm_account_lam_dev_count,
    dim_crm_account.is_base_prospect_account,

    -- Flags
    fct_crm_opportunity.is_won,
    fct_crm_opportunity.valid_deal_count,
    fct_crm_opportunity.is_closed,
    dim_crm_opportunity.is_edu_oss,
    dim_crm_opportunity.is_ps_opp,
    fct_crm_opportunity.is_sao,
    fct_crm_opportunity.is_win_rate_calc,
    fct_crm_opportunity.is_net_arr_pipeline_created,
    fct_crm_opportunity.is_net_arr_closed_deal,
    fct_crm_opportunity.is_new_logo_first_order,
    fct_crm_opportunity.is_closed_won,
    fct_crm_opportunity.is_web_portal_purchase,
    fct_crm_opportunity.is_stage_1_plus,
    fct_crm_opportunity.is_stage_3_plus,
    fct_crm_opportunity.is_stage_4_plus,
    fct_crm_opportunity.is_lost,
    fct_crm_opportunity.is_open,
    fct_crm_opportunity.is_active,
    dim_crm_opportunity.is_risky,
    fct_crm_opportunity.is_credit,
    fct_crm_opportunity.is_renewal,
    fct_crm_opportunity.is_refund,
    fct_crm_opportunity.is_deleted,
    fct_crm_opportunity.is_duplicate,
    fct_crm_opportunity.is_excluded_from_pipeline_created,
    fct_crm_opportunity.is_contract_reset,
    fct_crm_opportunity.is_comp_new_logo_override,
    fct_crm_opportunity.is_eligible_open_pipeline,
    fct_crm_opportunity.is_eligible_asp_analysis,
    fct_crm_opportunity.is_eligible_age_analysis,
    fct_crm_opportunity.is_eligible_churn_contraction,
    fct_crm_opportunity.is_booked_net_arr,
    fct_crm_opportunity.is_downgrade,
    dim_crm_opportunity.critical_deal_flag,
    fct_crm_opportunity.is_abm_tier_sao,
    fct_crm_opportunity.is_abm_tier_closed_won,

    -- Key Reporting Fields
    dim_crm_user_hierarchy.crm_user_sales_segment                 AS report_segment,
    dim_crm_user_hierarchy.crm_user_geo                           AS report_geo,
    dim_crm_user_hierarchy.crm_user_geo_pubsec_segment            AS report_geo_pubsec_segment,
    dim_crm_user_hierarchy.crm_user_region                        AS report_region,
    dim_crm_user_hierarchy.crm_user_area                          AS report_area,
    dim_crm_user_hierarchy.crm_user_business_unit                 AS report_business_unit,
    dim_crm_user_hierarchy.crm_user_role_name                     AS report_role_name,
    dim_crm_user_hierarchy.crm_user_role_level_1                  AS report_role_level_1,
    dim_crm_user_hierarchy.crm_user_role_level_2                  AS report_role_level_2,
    dim_crm_user_hierarchy.crm_user_role_level_3                  AS report_role_level_3,
    dim_crm_user_hierarchy.crm_user_role_level_4                  AS report_role_level_4,
    dim_crm_user_hierarchy.crm_user_role_level_5                  AS report_role_level_5,
    dim_crm_user_hierarchy.pipe_council_grouping,

    -- Channel fields
    fct_crm_opportunity.lead_source,
    fct_crm_opportunity.dr_partner_deal_type,
    fct_crm_opportunity.partner_account,
    partner_account.crm_account_name                              AS partner_account_name,
    partner_account.gitlab_partner_program                        AS partner_gitlab_program,
    dim_crm_opportunity.calculated_partner_track,
    fct_crm_opportunity.dr_status,
    fct_crm_opportunity.distributor,
    fct_crm_opportunity.dr_deal_id,
    fct_crm_opportunity.dr_primary_registration,
    fct_crm_opportunity.influence_partner,
    fct_crm_opportunity.fulfillment_partner,
    fulfillment_partner.crm_account_name                          AS fulfillment_partner_name,
    fct_crm_opportunity.platform_partner,
    fct_crm_opportunity.partner_track,
    fct_crm_opportunity.resale_partner_track,
    fct_crm_opportunity.is_public_sector_opp,
    fct_crm_opportunity.is_registration_from_portal,
    fct_crm_opportunity.calculated_discount,
    fct_crm_opportunity.partner_discount,
    fct_crm_opportunity.partner_discount_calc,
    fct_crm_opportunity.partner_margin_percentage,
    fct_crm_opportunity.comp_channel_neutral,
    fct_crm_opportunity.aggregate_partner,
    fct_crm_opportunity.count_crm_attribution_touchpoints,
    fct_crm_opportunity.weighted_linear_iacv,
    fct_crm_opportunity.count_campaigns,

    -- Solutions-Architech fields
    dim_crm_opportunity.sa_tech_evaluation_close_status,
    dim_crm_opportunity.sa_tech_evaluation_end_date,
    dim_crm_opportunity.sa_tech_evaluation_start_date,
    fct_crm_opportunity.number_of_sa_activity_tasks,

    --sales dev hierarchy fields
    dim_sales_dev_user_hierarchy.sales_dev_rep_user_full_name,
    dim_sales_dev_user_hierarchy.sales_dev_rep_manager_full_name,
    dim_sales_dev_user_hierarchy.sales_dev_rep_leader_full_name,
    dim_sales_dev_user_hierarchy.sales_dev_rep_user_role_level_1,
    dim_sales_dev_user_hierarchy.sales_dev_rep_user_role_level_2,
    dim_sales_dev_user_hierarchy.sales_dev_rep_user_role_level_3,

    --Command Plan fields
    dim_crm_opportunity.cp_partner,
    dim_crm_opportunity.cp_paper_process,
    dim_crm_opportunity.cp_help,
    dim_crm_opportunity.cp_review_notes,
    dim_crm_opportunity.cp_champion,
    dim_crm_opportunity.cp_close_plan,
    dim_crm_opportunity.cp_decision_criteria,
    dim_crm_opportunity.cp_decision_process,
    dim_crm_opportunity.cp_economic_buyer,
    dim_crm_opportunity.cp_identify_pain,
    dim_crm_opportunity.cp_metrics,
    dim_crm_opportunity.cp_risks,
    dim_crm_opportunity.cp_value_driver,
    dim_crm_opportunity.cp_why_do_anything_at_all,
    dim_crm_opportunity.cp_why_gitlab,
    dim_crm_opportunity.cp_why_now,
    dim_crm_opportunity.cp_score,
    dim_crm_opportunity.cp_use_cases,

    -- Competitor flags
    dim_crm_opportunity.competitors,
    dim_crm_opportunity.competitors_other_flag,
    dim_crm_opportunity.competitors_gitlab_core_flag,
    dim_crm_opportunity.competitors_none_flag,
    dim_crm_opportunity.competitors_github_enterprise_flag,
    dim_crm_opportunity.competitors_bitbucket_server_flag,
    dim_crm_opportunity.competitors_unknown_flag,
    dim_crm_opportunity.competitors_github_flag,
    dim_crm_opportunity.competitors_gitlab_flag,
    dim_crm_opportunity.competitors_jenkins_flag,
    dim_crm_opportunity.competitors_azure_devops_flag,
    dim_crm_opportunity.competitors_svn_flag,
    dim_crm_opportunity.competitors_bitbucket_flag,
    dim_crm_opportunity.competitors_atlassian_flag,
    dim_crm_opportunity.competitors_perforce_flag,
    dim_crm_opportunity.competitors_visual_studio_flag,
    dim_crm_opportunity.competitors_azure_flag,
    dim_crm_opportunity.competitors_amazon_code_commit_flag,
    dim_crm_opportunity.competitors_circleci_flag,
    dim_crm_opportunity.competitors_bamboo_flag,
    dim_crm_opportunity.competitors_aws_flag,

    -- Dates
    created_date.date_actual                                      AS created_date,
    created_date.first_day_of_month                               AS created_month,
    created_date.first_day_of_fiscal_quarter                      AS created_fiscal_quarter_date,
    created_date.fiscal_quarter_name_fy                           AS created_fiscal_quarter_name,
    created_date.fiscal_year                                      AS created_fiscal_year,
    sales_accepted_date.date_actual                               AS sales_accepted_date,
    sales_accepted_date.first_day_of_month                        AS sales_accepted_month,
    sales_accepted_date.first_day_of_fiscal_quarter               AS sales_accepted_fiscal_quarter_date,
    sales_accepted_date.fiscal_quarter_name_fy                    AS sales_accepted_fiscal_quarter_name,
    sales_accepted_date.fiscal_year                               AS sales_accepted_fiscal_year,
    close_date.date_actual                                        AS close_date,
    close_date.first_day_of_month                                 AS close_month,
    close_date.first_day_of_fiscal_quarter                        AS close_fiscal_quarter_date,
    close_date.fiscal_quarter_name_fy                             AS close_fiscal_quarter_name,
    close_date.fiscal_year                                        AS close_fiscal_year,
    stage_0_pending_acceptance_date.date_actual                   AS stage_0_pending_acceptance_date,
    stage_0_pending_acceptance_date.first_day_of_month            AS stage_0_pending_acceptance_month,
    stage_0_pending_acceptance_date.first_day_of_fiscal_quarter   AS stage_0_pending_acceptance_fiscal_quarter_date,
    stage_0_pending_acceptance_date.fiscal_quarter_name_fy        AS stage_0_pending_acceptance_fiscal_quarter_name,
    stage_0_pending_acceptance_date.fiscal_year                   AS stage_0_pending_acceptance_fiscal_year,
    stage_1_discovery_date.date_actual                            AS stage_1_discovery_date,
    stage_1_discovery_date.first_day_of_month                     AS stage_1_discovery_month,
    stage_1_discovery_date.first_day_of_fiscal_quarter            AS stage_1_discovery_fiscal_quarter_date,
    stage_1_discovery_date.fiscal_quarter_name_fy                 AS stage_1_discovery_fiscal_quarter_name,
    stage_1_discovery_date.fiscal_year                            AS stage_1_discovery_fiscal_year,
    stage_2_scoping_date.date_actual                              AS stage_2_scoping_date,
    stage_2_scoping_date.first_day_of_month                       AS stage_2_scoping_month,
    stage_2_scoping_date.first_day_of_fiscal_quarter              AS stage_2_scoping_fiscal_quarter_date,
    stage_2_scoping_date.fiscal_quarter_name_fy                   AS stage_2_scoping_fiscal_quarter_name,
    stage_2_scoping_date.fiscal_year                              AS stage_2_scoping_fiscal_year,
    stage_3_technical_evaluation_date.date_actual                 AS stage_3_technical_evaluation_date,
    stage_3_technical_evaluation_date.first_day_of_month          AS stage_3_technical_evaluation_month,
    stage_3_technical_evaluation_date.first_day_of_fiscal_quarter AS stage_3_technical_evaluation_fiscal_quarter_date,
    stage_3_technical_evaluation_date.fiscal_quarter_name_fy      AS stage_3_technical_evaluation_fiscal_quarter_name,
    stage_3_technical_evaluation_date.fiscal_year                 AS stage_3_technical_evaluation_fiscal_year,
    stage_4_proposal_date.date_actual                             AS stage_4_proposal_date,
    stage_4_proposal_date.first_day_of_month                      AS stage_4_proposal_month,
    stage_4_proposal_date.first_day_of_fiscal_quarter             AS stage_4_proposal_fiscal_quarter_date,
    stage_4_proposal_date.fiscal_quarter_name_fy                  AS stage_4_proposal_fiscal_quarter_name,
    stage_4_proposal_date.fiscal_year                             AS stage_4_proposal_fiscal_year,
    stage_5_negotiating_date.date_actual                          AS stage_5_negotiating_date,
    stage_5_negotiating_date.first_day_of_month                   AS stage_5_negotiating_month,
    stage_5_negotiating_date.first_day_of_fiscal_quarter          AS stage_5_negotiating_fiscal_quarter_date,
    stage_5_negotiating_date.fiscal_quarter_name_fy               AS stage_5_negotiating_fiscal_quarter_name,
    stage_5_negotiating_date.fiscal_year                          AS stage_5_negotiating_fiscal_year,
    stage_6_awaiting_signature_date.date_actual                   AS stage_6_awaiting_signature_date_date,
    stage_6_awaiting_signature_date.first_day_of_month            AS stage_6_awaiting_signature_date_month,
    stage_6_awaiting_signature_date.first_day_of_fiscal_quarter   AS stage_6_awaiting_signature_date_fiscal_quarter_date,
    stage_6_awaiting_signature_date.fiscal_quarter_name_fy        AS stage_6_awaiting_signature_date_fiscal_quarter_name,
    stage_6_awaiting_signature_date.fiscal_year                   AS stage_6_awaiting_signature_date_fiscal_year,
    stage_6_closed_won_date.date_actual                           AS stage_6_closed_won_date,
    stage_6_closed_won_date.first_day_of_month                    AS stage_6_closed_won_month,
    stage_6_closed_won_date.first_day_of_fiscal_quarter           AS stage_6_closed_won_fiscal_quarter_date,
    stage_6_closed_won_date.fiscal_quarter_name_fy                AS stage_6_closed_won_fiscal_quarter_name,
    stage_6_closed_won_date.fiscal_year                           AS stage_6_closed_won_fiscal_year,
    stage_6_closed_lost_date.date_actual                          AS stage_6_closed_lost_date,
    stage_6_closed_lost_date.first_day_of_month                   AS stage_6_closed_lost_month,
    stage_6_closed_lost_date.first_day_of_fiscal_quarter          AS stage_6_closed_lost_fiscal_quarter_date,
    stage_6_closed_lost_date.fiscal_quarter_name_fy               AS stage_6_closed_lost_fiscal_quarter_name,
    stage_6_closed_lost_date.fiscal_year                          AS stage_6_closed_lost_fiscal_year,
    subscription_start_date.date_actual                           AS subscription_start_date,
    subscription_start_date.first_day_of_month                    AS subscription_start_month,
    subscription_start_date.first_day_of_fiscal_quarter           AS subscription_start_fiscal_quarter_date,
    subscription_start_date.fiscal_quarter_name_fy                AS subscription_start_fiscal_quarter_name,
    subscription_start_date.fiscal_year                           AS subscription_start_fiscal_year,
    subscription_end_date.date_actual                             AS subscription_end_date,
    subscription_end_date.first_day_of_month                      AS subscription_end_month,
    subscription_end_date.first_day_of_fiscal_quarter             AS subscription_end_fiscal_quarter_date,
    subscription_end_date.fiscal_quarter_name_fy                  AS subscription_end_fiscal_quarter_name,
    subscription_end_date.fiscal_year                             AS subscription_end_fiscal_year,
    sales_qualified_date.date_actual                              AS sales_qualified_date,
    sales_qualified_date.first_day_of_month                       AS sales_qualified_month,
    sales_qualified_date.first_day_of_fiscal_quarter              AS sales_qualified_fiscal_quarter_date,
    sales_qualified_date.fiscal_quarter_name_fy                   AS sales_qualified_fiscal_quarter_name,
    sales_qualified_date.fiscal_year                              AS sales_qualified_fiscal_year,
    last_activity_date.date_actual                                AS last_activity_date,
    last_activity_date.first_day_of_month                         AS last_activity_month,
    last_activity_date.first_day_of_fiscal_quarter                AS last_activity_fiscal_quarter_date,
    last_activity_date.fiscal_quarter_name_fy                     AS last_activity_fiscal_quarter_name,
    last_activity_date.fiscal_year                                AS last_activity_fiscal_year,
    sales_last_activity_date.date_actual                          AS sales_last_activity_date,
    sales_last_activity_date.first_day_of_month                   AS sales_last_activity_month,
    sales_last_activity_date.first_day_of_fiscal_quarter          AS sales_last_activity_fiscal_quarter_date,
    sales_last_activity_date.fiscal_quarter_name_fy               AS sales_last_activity_fiscal_quarter_name,
    sales_last_activity_date.fiscal_year                          AS sales_last_activity_fiscal_year,
    technical_evaluation_date.date_actual                         AS technical_evaluation_date,
    technical_evaluation_date.first_day_of_month                  AS technical_evaluation_month,
    technical_evaluation_date.first_day_of_fiscal_quarter         AS technical_evaluation_fiscal_quarter_date,
    technical_evaluation_date.fiscal_quarter_name_fy              AS technical_evaluation_fiscal_quarter_name,
    technical_evaluation_date.fiscal_year                         AS technical_evaluation_fiscal_year,
    arr_created_date.date_actual                                  AS arr_created_date,
    arr_created_date.first_day_of_month                           AS arr_created_month,
    arr_created_date.first_day_of_fiscal_quarter                  AS arr_created_fiscal_quarter_date,
    arr_created_date.fiscal_quarter_name_fy                       AS arr_created_fiscal_quarter_name,
    arr_created_date.fiscal_year                                  AS arr_created_fiscal_year,
    arr_created_date.date_actual                                  AS pipeline_created_date,
    arr_created_date.first_day_of_month                           AS pipeline_created_month,
    arr_created_date.first_day_of_fiscal_quarter                  AS pipeline_created_fiscal_quarter_date,
    arr_created_date.fiscal_quarter_name_fy                       AS pipeline_created_fiscal_quarter_name,
    arr_created_date.fiscal_year                                  AS pipeline_created_fiscal_year,
    arr_created_date.date_actual                                  AS net_arr_created_date,
    arr_created_date.first_day_of_month                           AS net_arr_created_month,
    arr_created_date.first_day_of_fiscal_quarter                  AS net_arr_created_fiscal_quarter_date,
    arr_created_date.fiscal_quarter_name_fy                       AS net_arr_created_fiscal_quarter_name,
    arr_created_date.fiscal_year                                  AS net_arr_created_fiscal_year,
    fct_crm_opportunity.days_in_0_pending_acceptance,
    fct_crm_opportunity.days_in_1_discovery,
    fct_crm_opportunity.days_in_2_scoping,
    fct_crm_opportunity.days_in_3_technical_evaluation,
    fct_crm_opportunity.days_in_4_proposal,
    fct_crm_opportunity.days_in_5_negotiating,
    fct_crm_opportunity.days_in_sao,
    fct_crm_opportunity.calculated_age_in_days,
    fct_crm_opportunity.days_since_last_activity,
    dim_crm_opportunity.subscription_renewal_date,

    --additive fields
    fct_crm_opportunity.arr_basis,
    fct_crm_opportunity.iacv,
    fct_crm_opportunity.net_iacv,
    fct_crm_opportunity.opportunity_based_iacv_to_net_arr_ratio,
    fct_crm_opportunity.segment_order_type_iacv_to_net_arr_ratio,
    fct_crm_opportunity.calculated_from_ratio_net_arr,
    fct_crm_opportunity.net_arr,
    fct_crm_opportunity.net_arr_stage_1,
    fct_crm_opportunity.xdr_net_arr_stage_1,
    fct_crm_opportunity.xdr_net_arr_stage_3,
    fct_crm_opportunity.enterprise_agile_planning_net_arr,
    fct_crm_opportunity.duo_net_arr,
    fct_crm_opportunity.raw_net_arr,
    fct_crm_opportunity.created_and_won_same_quarter_net_arr,
    fct_crm_opportunity.new_logo_count,
    fct_crm_opportunity.amount,
    fct_crm_opportunity.open_1plus_deal_count,
    fct_crm_opportunity.open_3plus_deal_count,
    fct_crm_opportunity.open_4plus_deal_count,
    fct_crm_opportunity.booked_deal_count,
    fct_crm_opportunity.churned_contraction_deal_count,
    fct_crm_opportunity.open_1plus_net_arr,
    fct_crm_opportunity.open_3plus_net_arr,
    fct_crm_opportunity.open_4plus_net_arr,
    fct_crm_opportunity.booked_net_arr,
    fct_crm_opportunity.churned_contraction_net_arr,
    fct_crm_opportunity.calculated_deal_count,
    fct_crm_opportunity.booked_churned_contraction_deal_count,
    fct_crm_opportunity.booked_churned_contraction_net_arr,
    fct_crm_opportunity.arr,
    fct_crm_opportunity.recurring_amount,
    fct_crm_opportunity.true_up_amount,
    fct_crm_opportunity.proserv_amount,
    fct_crm_opportunity.other_non_recurring_amount,
    fct_crm_opportunity.renewal_amount,
    fct_crm_opportunity.total_contract_value,
    fct_crm_opportunity.days_in_stage,
    fct_crm_opportunity.vsa_start_date_net_arr,
    fct_crm_opportunity.won_arr_basis_for_clari,
    fct_crm_opportunity.arr_basis_for_clari,
    fct_crm_opportunity.forecasted_churn_for_clari,
    fct_crm_opportunity.override_arr_basis_clari,
    fct_crm_opportunity.cycle_time_in_days,
    fct_crm_opportunity.created_arr,
    fct_crm_opportunity.closed_won_opps,
    fct_crm_opportunity.closed_opps,
    fct_crm_opportunity.created_deals,
    fct_crm_opportunity.positive_booked_deal_count,
    fct_crm_opportunity.positive_booked_net_arr,
    fct_crm_opportunity.positive_open_deal_count,
    fct_crm_opportunity.positive_open_net_arr,
    fct_crm_opportunity.closed_deals,
    fct_crm_opportunity.closed_net_arr


  FROM fct_crm_opportunity
  LEFT JOIN dim_crm_opportunity
    ON fct_crm_opportunity.dim_crm_opportunity_id = dim_crm_opportunity.dim_crm_opportunity_id
  LEFT JOIN dim_crm_account
    ON dim_crm_opportunity.dim_crm_account_id = dim_crm_account.dim_crm_account_id
  LEFT JOIN dim_sales_qualified_source
    ON fct_crm_opportunity.dim_sales_qualified_source_id = dim_sales_qualified_source.dim_sales_qualified_source_id
  LEFT JOIN dim_deal_path
    ON fct_crm_opportunity.dim_deal_path_id = dim_deal_path.dim_deal_path_id
  LEFT JOIN dim_order_type
    ON fct_crm_opportunity.dim_order_type_id = dim_order_type.dim_order_type_id
  LEFT JOIN dim_order_type AS dim_order_type_current
    ON fct_crm_opportunity.dim_order_type_current_id = dim_order_type_current.dim_order_type_id
  LEFT JOIN dim_dr_partner_engagement
    ON fct_crm_opportunity.dim_dr_partner_engagement_id = dim_dr_partner_engagement.dim_dr_partner_engagement_id
  LEFT JOIN dim_alliance_type
    ON fct_crm_opportunity.dim_alliance_type_id = dim_alliance_type.dim_alliance_type_id
  LEFT JOIN dim_channel_type
    ON fct_crm_opportunity.dim_channel_type_id = dim_channel_type.dim_channel_type_id
  LEFT JOIN dim_date AS close_date
    ON fct_crm_opportunity.close_date_id = close_date.date_id
  LEFT JOIN dim_crm_user_hierarchy
    ON fct_crm_opportunity.dim_crm_current_account_set_hierarchy_sk = dim_crm_user_hierarchy.dim_crm_user_hierarchy_sk
  LEFT JOIN dim_date AS created_date
    ON fct_crm_opportunity.created_date_id = created_date.date_id
  LEFT JOIN dim_date AS sales_accepted_date
    ON fct_crm_opportunity.sales_accepted_date_id = sales_accepted_date.date_id
  LEFT JOIN dim_date AS stage_0_pending_acceptance_date
    ON fct_crm_opportunity.stage_0_pending_acceptance_date_id = stage_0_pending_acceptance_date.date_id
  LEFT JOIN dim_date AS stage_1_discovery_date
    ON fct_crm_opportunity.stage_1_discovery_date_id = stage_1_discovery_date.date_id
  LEFT JOIN dim_date AS stage_2_scoping_date
    ON fct_crm_opportunity.stage_2_scoping_date_id = stage_2_scoping_date.date_id
  LEFT JOIN dim_date AS stage_3_technical_evaluation_date
    ON fct_crm_opportunity.stage_3_technical_evaluation_date_id = stage_3_technical_evaluation_date.date_id
  LEFT JOIN dim_date AS stage_4_proposal_date
    ON fct_crm_opportunity.stage_4_proposal_date_id = stage_4_proposal_date.date_id
  LEFT JOIN dim_date AS stage_5_negotiating_date
    ON fct_crm_opportunity.stage_5_negotiating_date_id = stage_5_negotiating_date.date_id
  LEFT JOIN dim_date AS stage_6_awaiting_signature_date
    ON fct_crm_opportunity.stage_6_awaiting_signature_date_id = stage_6_awaiting_signature_date.date_id
  LEFT JOIN dim_date AS stage_6_closed_won_date
    ON fct_crm_opportunity.stage_6_closed_won_date_id = stage_6_closed_won_date.date_id
  LEFT JOIN dim_date AS stage_6_closed_lost_date
    ON fct_crm_opportunity.stage_6_closed_lost_date_id = stage_6_closed_lost_date.date_id
  LEFT JOIN dim_date AS subscription_start_date
    ON fct_crm_opportunity.subscription_start_date_id = subscription_start_date.date_id
  LEFT JOIN dim_date AS subscription_end_date
    ON fct_crm_opportunity.subscription_end_date_id = subscription_end_date.date_id
  LEFT JOIN dim_date AS sales_qualified_date
    ON fct_crm_opportunity.sales_qualified_date_id = sales_qualified_date.date_id
  LEFT JOIN dim_date AS last_activity_date
    ON fct_crm_opportunity.last_activity_date_id = last_activity_date.date_id
  LEFT JOIN dim_date AS sales_last_activity_date
    ON fct_crm_opportunity.sales_last_activity_date_id = sales_last_activity_date.date_id
  LEFT JOIN dim_date AS technical_evaluation_date
    ON fct_crm_opportunity.technical_evaluation_date_id = technical_evaluation_date.date_id
  LEFT JOIN dim_date AS arr_created_date
    ON fct_crm_opportunity.arr_created_date_id = arr_created_date.date_id
  LEFT JOIN dim_crm_account AS partner_account
    ON fct_crm_opportunity.partner_account = partner_account.dim_crm_account_id
  LEFT JOIN dim_crm_account AS fulfillment_partner
    ON fct_crm_opportunity.fulfillment_partner = fulfillment_partner.dim_crm_account_id
  LEFT JOIN dim_crm_user
    ON fct_crm_opportunity.dim_crm_user_id = dim_crm_user.dim_crm_user_id
  LEFT JOIN {{ ref('dim_sales_dev_user_hierarchy') }}
    ON fct_crm_opportunity.dim_crm_person_id = dim_sales_dev_user_hierarchy.dim_crm_user_id
      AND fct_crm_opportunity.stage_1_discovery_date = dim_sales_dev_user_hierarchy.snapshot_date

)

{{ dbt_audit(
    cte_ref="final",
    created_by="@iweeks",
    updated_by="@jonglee1218",
    created_date="2020-12-07",
    updated_date="2025-02-06"
  ) }}

