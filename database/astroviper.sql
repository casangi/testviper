-- CREATE TABLE statements

-- Test Suites Table
CREATE TABLE IF NOT EXISTS test_suites (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    component VARCHAR(255) NOT NULL,
    branch VARCHAR(255) NOT NULL,
    tests INTEGER DEFAULT 0,
    failures INTEGER DEFAULT 0,
    errors INTEGER DEFAULT 0,
    skipped INTEGER DEFAULT 0,
    time DECIMAL(10, 6) DEFAULT 0.0,
    timestamp VARCHAR(50),
    hostname VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Test Cases Table
CREATE TABLE IF NOT EXISTS test_cases (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    suite_id INTEGER NOT NULL,
    classname VARCHAR(500),
    name VARCHAR(500) NOT NULL,
    time DECIMAL(10, 6) DEFAULT 0.0,
    file VARCHAR(500),
    line VARCHAR(20),
    status TEXT CHECK( status IN ('PASSED', 'FAILED', 'ERROR', 'SKIPPED')) NOT NULL,
    failure_message TEXT,
    failure_type VARCHAR(255),
    failure_text TEXT,
    error_message TEXT,
    error_type VARCHAR(255),
    error_text TEXT,
    skip_message TEXT,
    skip_reason TEXT,
    system_out TEXT,
    system_err TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (suite_id) REFERENCES test_suites(id)
);


-- INSERT statements
INSERT OR IGNORE INTO test_suites (id, name, component, branch, tests, failures, errors, skipped, time, timestamp, hostname) 
VALUES (300880548164077361, 'pytest', 'astroviper', '23-grafana-dashboard', 193, 
        0, 0, 0, 47.592, 
        '2025-09-10T18:41:52.141118+00:00', 'runnervmf4ws1');

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077362, 300880548164077361, 'tests.unit.core.imaging.test_fft_ifft.FFTTest', 'test_fft_ifft_round_trip', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077363, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_two_components_with_world_coords[0.02]', 1.513, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077364, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_two_components_with_world_coords[0.05]', 0.98, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077365, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_vectorize_over_time_names_and_indices', 0.136, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077366, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_flags_and_descending_world_coords', 0.077, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077367, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_auto_seeds_when_initial_none', 0.043, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077368, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_accepts_raw_numpy_array', 0.026, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077369, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_accepts_bare_dask_array', 0.13, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077370, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_world_coords_skipped_for_bad_axis_coords', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077371, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_bounds_merge_tuple_all_and_unknown_key_ignored', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077372, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_bounds_merge_per_component_length_error', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077373, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_dims_by_index_and_error_paths', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077374, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_init_formats_and_errors', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077375, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_full_mask_triggers_failure_and_nan_planes', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077376, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_exception_sets_failure', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077377, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_pcov_none_sets_errors_nan', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077378, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_with_valid_pcov_sets_finite_errors', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077379, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_nonfinite_popt_triggers_not_success_nan_outputs', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077380, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_pcov_wrong_shape_sets_errors_nan_success_true', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077381, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesTopLevelListOfDicts', 'test_top_level_list_of_dicts_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077382, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesTopLevelListOfDicts', 'test_top_level_list_of_dicts_happy_path_parses_and_packs', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077383, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesPublicAPIWrapping', 'test_single_dict_shorthand_is_wrapped_and_used', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077384, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_3d_with_indexer_and_no_component_dim', 0.082, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077385, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_defaults_indexer_for_3d_input', 0.047, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077386, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_selects_result_plane_with_default_indexer', 0.056, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077387, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_default_indexer_loops_multiple_dims', 0.066, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077388, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_else_branch_for_2d_input', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077389, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_raises_when_result_missing_required_var', 0.03, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077390, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_fwhm_converts_from_sigma_when_fwhm_missing', 0.029, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077391, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_fwhm_warns_and_draws_without_size_when_both_missing', 0.033, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077392, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_overlay_converts_fwhm_to_sigma_when_sigma_missing', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077393, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_min_threshold_masks_pixels_partial', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077394, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_max_threshold_masks_pixels_partial', 0.025, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077395, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_conversion_and_reporting', 0.028, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077396, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_conversion_list_of_dicts', 0.047, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077397, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_array_dict_converted', 0.026, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077398, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_list_of_dicts_converted', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077399, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_list_of_dicts_missing_theta_covers_if_false_branch', 0.037, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077400, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_list_of_dicts_branch', 0.043, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077401, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_plot_components_uses_model_branch_and_slices_leading_dims', 0.038, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077402, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_pixel_fit_interpolates_world_centers_and_propagates_errors_ascending', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077403, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_pixel_fit_interpolates_world_centers_descending_x', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077404, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_array_wrong_shape_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077405, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077406, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_happy_path_synonyms_and_theta_default', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077407, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_missing_keys_raise', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077408, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_happy_path_covers_224_232', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077409, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_tuple_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077410, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_tuple_happy_path_covers_224_to_232', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077411, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_array_list_form_fallback_covers_234_235', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077412, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_bounds_offset_branch_public_api', 0.024, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077413, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_bounds_per_component_list_public_api_hits_comp_idx_branch', 0.058, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077414, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_public_api_ensure_dataarray_raises_on_unsupported_type', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077415, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_resolve_dims_raises_for_3d_without_dims', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077416, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_public_api_n_components_must_be_positive', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077417, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_initial_guesses_list_of_dicts_wrong_length_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077418, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_array_wrong_shape_hits_conv_arr_early_return_then_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077419, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestMetadataNotes', 'test_variance_explained_includes_self_documenting_note', 0.022, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077420, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_canonicalization_swaps_axes_and_rotates_theta_by_half_pi', 0.024, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077421, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_canonicalization_wraps_theta_into_half_pi_interval', 0.047, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077422, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_theta_math_pa_relation_pixel_right_and_left_handed', 0.291, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077423, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInnerPrepCoverage', 'test_inner_prep_lines_executed', 0.015, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077424, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_coords_validation_and_success', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077425, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_numpy_input_coords_tuple_happy_path_returns_y1d_x1d', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077426, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_numpy_input_coords_tuple_wrong_lengths_raise', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077427, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataVersion', 'test_version_fallback_reads_package_dunder', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077428, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataVersion', 'test_version_fallback_unknown_when_no_dunder', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077429, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsFwhmMapping', 'test_fwhm_major_list_of_tuples_maps_to_sigma_x_per_component', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077430, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsFwhmMapping', 'test_fwhm_minor_single_tuple_maps_to_sigma_y_tuple', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077431, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesFwhmMinorMappingPublicAPI', 'test_components_list_of_dicts_maps_fwhm_minor_to_sigma_y_in_p0', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077432, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAutoSeedingPixelPublicAPI', 'test_auto_seed_pixel_public_api', 0.04, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077433, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAutoSeedingPixelElsePublicAPI', 'test_auto_seeding_pixel_else_path_public_api', 0.017, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077434, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataShortener', 'test_coords_repr_truncated_when_shape_property_raises', 0.015, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077435, 300880548164077361, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestWorldSeeding', 'test_autoseed_uses_world_axes_and_recovers_params', 0.132, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077436, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_box_with_and_without_header_0based_and_area', 0.036, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077437, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_circle_centroid_near_center', 0.047, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077438, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_rotbox_ellipse_parse_and_nonempty[rotbox-rotbox[[120pix,80pix],[60pix,30pix], theta_m=30]]', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077439, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_rotbox_ellipse_parse_and_nonempty[ellipse-ellipse[[120pix,80pix],[50pix,25pix], theta_m=60]]', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077440, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFCombine', 'test_multi_line_plus_minus_matches_boolean_ops', 0.065, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077441, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_roi_and_not_bad', 0.04, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077442, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_invalid_minus_not_raises', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077443, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_unknown_name_keyerror_lists_available', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077444, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_syntax_error_raises_value_error', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077445, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_with_xarray_dataset_mask_source', 0.036, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077446, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_mask_source_typeerror_when_not_mapping_or_dataset', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077447, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_mask_source_empty_raises_value_error', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077448, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_unsupported_construct_compare_raises', 0.02, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077449, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_boolop_and_or_forbidden_raises', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077450, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_bitwise_and_or_xor_return_paths', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077451, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_constant_true_false_returns_bool_arrays', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077452, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestToBoolCasting', 'test_numeric_masks_nan_to_false_and_casting', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077453, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_backticked_file_and_path_object_match_inline', 0.097, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077454, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_missing_backticked_file_raises_file_not_found', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077455, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_missing_path_object_raises_file_not_found', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077456, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_plain_string_not_backticked_is_parsed_as_text_via_public_api', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077457, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_non_string_non_path_select_raises_typeerror_public_api', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077458, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestErrorMessages', 'test_box_without_pix_suggests_pix_units', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077459, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestErrorMessages', 'test_centerbox_without_pix_in_sizes_suggests_pix_units', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077460, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestUnsupportedSelectType', 'test_unsupported_select_type_typeerror_message', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077461, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestApplySelect', 'test_apply_select_sets_outside_to_nan', 0.032, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077462, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestApplySelect', 'test_full_image_box_selects_all_pixels', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077463, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestApplySelect', 'test_apply_select_numpy_branch_sets_outside_nan_preserves_inside', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077464, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_convex_square_membership_and_invariance', 0.159, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077465, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_concave_arrow_shape_includes_and_excludes_expected_points', 0.122, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077466, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_polygon_with_float_vertices_behaves_sensibly', 0.065, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077467, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_polygon_file_roundtrip_matches_inline', 0.066, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077468, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestNumpyMaskAlignment', 'test_numpy_float_mask_nan_to_false_and_broadcast', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077469, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestNumpyMaskAlignment', 'test_numpy_mask_broadcast_error_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077470, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestAllTrueMaskLike', 'test_none_select_numpy_returns_all_true', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077471, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestAllTrueMaskLike', 'test_none_select_xarray_returns_all_true', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077472, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestSmartSplitPairs', 'test_annulus_equals_circle_diff_and_trims_trailing_space', 0.045, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077473, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestXarrayMaskAlignment', 'test_xarray_float_mask_with_nan_fillna_false', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077474, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_numpy_from_expression', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077475, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_from_crtf', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077476, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dataarray_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077477, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dataarray_dask_and_apply_select', 0.017, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077478, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_wrap_numpy_mask_to_dask_dataarray', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077479, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dataarray_numpy_from_numpy_mask_numpy_data_hits_else_branch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077480, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dataarray_numpy_from_xarray_dask_mask_xarray_data_computes', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077481, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_from_xarray_dask_mask_returns_dask_array', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077482, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_wraps_xarray_numpy_mask_using_inferred_or_given_chunks', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077483, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_wraps_numpy_mask_when_data_is_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077484, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dask_return_kind_infers_chunks_from_data_success', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077485, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dask_return_kind_infer_chunks_exception_path_without_monkeypatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077486, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dataarray_numpy_else_branch_creation_attached_and_printed', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077487, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFDirectives', 'test_global_directive_lines_are_ignored', 0.024, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077488, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCreationAutoMerge', 'test_auto_merge_creation_from_triplet_attrs', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077489, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCreationAutoMerge', 'test_auto_merge_creation_falls_back_to_single_creation_attr', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077490, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestAlignFallback', 'test_broadcast_like_exception_fallback_numpy_wrap_success', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077491, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestAlignFallback', 'test_fallback_broadcast_to_failure_raises_valueerror', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077492, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_invalid_op_raises', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077493, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_or_and_xor_semantics_and_creation_merge_default', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077494, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_creation_hint_overrides', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077495, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_template_controls_dims_and_return_kind_numpy', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077496, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_dask_chunks_applied_when_requesting_dask_return_kind', 0.006, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077497, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestDataArrayMaskConstructorFallback', 'test_dims_constructor_raises_and_fallback_without_dims_used', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077498, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationRenameExcept', 'test_template_rename_exception_path_falls_back_and_succeeds', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077499, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestToBoolDataArray', 'test_dataarray_float_nan_fillna_before_bool', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077500, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFMalformed', 'test_crtf_invalid_line_raises', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077501, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFNumericParsingErrors', 'test_invalid_numeric_token_in_angle_raises_value_error', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077502, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFNumericParsingErrors', 'test_invalid_pixel_quantity_token_raises_specific_message', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077503, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCreationAssignmentInDataArrayNumpyReturn', 'test_creation_hint_attached_in_dataarray_numpy_else_branch', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077504, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationRenameDoubleExcept', 'test_rename_and_constructor_fallback_both_raise_then_pass', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077505, 300880548164077361, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFPA', 'test_rotbox_pa_equivalent_to_theta_m', 0.151, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077506, 300880548164077361, 'tests.unit.distributed.imaging.test_feather.FeatherTest', 'test_feather', 25.81, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077507, 300880548164077361, 'tests.unit.distributed.imaging.test_feather.FeatherTest', 'test_overwrite', 1.032, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077508, 300880548164077361, 'tests.unit.distributed.imaging.test_feather.FeatherModelComparison', 'test_basic_stats_and_positions', 9.346, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077509, 300880548164077361, 'tests.unit.distributed.imaging.test_feather.FeatherModelComparison', 'test_center_region_and_width_inference', 0.397, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077510, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_auto_uses_math_on_right_handed_grid', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077511, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_auto_uses_pa_on_left_handed_grid', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077512, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_degrees_flag', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077513, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_add_false_replaces_inside', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077514, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_add_true_adds_only_inside', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077515, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_output_kinds_numpy_and_dask', 0.076, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077516, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_param_validation', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077517, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_add_true_adds_gaussian', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077518, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_decreasing_x_coords_ok', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077519, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_output_kinds', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077520, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_peak_at_center_replacement', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077521, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_add_true_adds_to_existing', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077522, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_midpoint_tie_chooses_right', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077523, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_output_kinds_numpy_and_dask', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077524, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_requires_equal_lengths', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077525, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_sum_duplicates', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077526, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_length_mismatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077527, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_missing_coord_keys', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077528, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_rejects_non_2d_numpy', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077529, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_rejects_unsupported_type', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077530, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_requires_coords_for_raw_arrays', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077531, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_non_monotonic_x_raises', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077532, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_non_monotonic_y_raises', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077533, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_requires_len_ge_2', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077534, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_clip_clamps', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077535, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_error_policy_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077536, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_ignore_returns_mask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077537, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_ignore_sloppy_keeps_half_pixel', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077538, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutput', 'test_invalid_output_kind_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077539, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestParamValidation', 'test_make_disk_param_validation', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077540, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestParamValidation', 'test_make_gauss2d_param_validation', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077541, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_length_at_least_one', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077542, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_must_be_1d', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077543, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_strictly_monotonic', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077544, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_descending_branch_maps_back', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077545, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_invalid_out_of_range_value_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077546, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_dask_to_numpy_compute_line', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077547, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_dask', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077548, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_dataarray', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077549, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077550, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_numpy_to_dask_wrap_line', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077551, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_clip_with_mask_size_one', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077552, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_ignore_plain_return_no_mask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077553, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_ignore_sloppy_size_one_validity', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (300880548164077554, 300880548164077361, 'tests.unit.distributed.model.test_component_models.TestMakePtSourcesEarlyExit', 'test_all_out_of_range_early_exit', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);