-- CREATE TABLE statements

-- Test Suites Table
CREATE TABLE IF NOT EXISTS test_suites (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
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
INSERT OR IGNORE INTO test_suites (id, name, tests, failures, errors, skipped, time, timestamp, hostname) 
VALUES (303023617039413666, 'pytest', 123, 
        0, 0, 0, 49.047, 
        '2025-09-04T21:19:25.042058+00:00', 'pkrvm7jw40e0xgp');

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413667, 303023617039413666, 'tests.unit.core.imaging.test_fft_ifft.FFTTest', 'test_fft_ifft_round_trip', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413668, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_two_components_with_world_coords[0.02]', 1.154, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413669, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_two_components_with_world_coords[0.05]', 1.366, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413670, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_vectorize_over_time_names_and_indices', 0.133, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413671, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_flags_and_descending_world_coords', 0.079, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413672, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_auto_seeds_when_initial_none', 0.046, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413673, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_accepts_raw_numpy_array', 0.028, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413674, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_accepts_bare_dask_array', 0.135, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413675, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_world_coords_skipped_for_bad_axis_coords', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413676, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_bounds_merge_tuple_all_and_unknown_key_ignored', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413677, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_bounds_merge_per_component_length_error', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413678, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_dims_by_index_and_error_paths', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413679, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_init_formats_and_errors', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413680, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_full_mask_triggers_failure_and_nan_planes', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413681, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_exception_sets_failure', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413682, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_pcov_none_sets_errors_nan', 0.015, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413683, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_with_valid_pcov_sets_finite_errors', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413684, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_nonfinite_popt_triggers_not_success_nan_outputs', 0.015, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413685, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_pcov_wrong_shape_sets_errors_nan_success_true', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413686, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesTopLevelListOfDicts', 'test_top_level_list_of_dicts_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413687, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesTopLevelListOfDicts', 'test_top_level_list_of_dicts_happy_path_parses_and_packs', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413688, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesPublicAPIWrapping', 'test_single_dict_shorthand_is_wrapped_and_used', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413689, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_3d_with_indexer_and_no_component_dim', 0.084, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413690, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_defaults_indexer_for_3d_input', 0.054, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413691, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_selects_result_plane_with_default_indexer', 0.059, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413692, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_default_indexer_loops_multiple_dims', 0.073, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413693, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_else_branch_for_2d_input', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413694, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_raises_when_result_missing_required_var', 0.036, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413695, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_fwhm_converts_from_sigma_when_fwhm_missing', 0.035, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413696, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_fwhm_warns_and_draws_without_size_when_both_missing', 0.037, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413697, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_overlay_converts_fwhm_to_sigma_when_sigma_missing', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413698, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_min_threshold_masks_pixels_partial', 0.023, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413699, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_max_threshold_masks_pixels_partial', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413700, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_conversion_and_reporting', 0.029, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413701, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_conversion_list_of_dicts', 0.048, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413702, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_array_dict_converted', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413703, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_list_of_dicts_converted', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413704, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_list_of_dicts_missing_theta_covers_if_false_branch', 0.038, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413705, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_list_of_dicts_branch', 0.045, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413706, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_plot_components_uses_model_branch_and_slices_leading_dims', 0.046, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413707, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_pixel_fit_interpolates_world_centers_and_propagates_errors_ascending', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413708, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_pixel_fit_interpolates_world_centers_descending_x', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413709, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_array_wrong_shape_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413710, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413711, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_happy_path_synonyms_and_theta_default', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413712, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_missing_keys_raise', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413713, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_happy_path_covers_224_232', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413714, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_tuple_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413715, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_tuple_happy_path_covers_224_to_232', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413716, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_array_list_form_fallback_covers_234_235', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413717, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_bounds_offset_branch_public_api', 0.026, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413718, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_bounds_per_component_list_public_api_hits_comp_idx_branch', 0.061, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413719, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_public_api_ensure_dataarray_raises_on_unsupported_type', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413720, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_resolve_dims_raises_for_3d_without_dims', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413721, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_public_api_n_components_must_be_positive', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413722, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_initial_guesses_list_of_dicts_wrong_length_raises', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413723, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_array_wrong_shape_hits_conv_arr_early_return_then_raises', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413724, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestMetadataNotes', 'test_variance_explained_includes_self_documenting_note', 0.024, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413725, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_canonicalization_swaps_axes_and_rotates_theta_by_half_pi', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413726, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_canonicalization_wraps_theta_into_half_pi_interval', 0.051, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413727, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_theta_math_pa_relation_pixel_right_and_left_handed', 0.296, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413728, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInnerPrepCoverage', 'test_inner_prep_lines_executed', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413729, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_coords_validation_and_success', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413730, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_numpy_input_coords_tuple_happy_path_returns_y1d_x1d', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413731, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_numpy_input_coords_tuple_wrong_lengths_raise', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413732, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataVersion', 'test_version_fallback_reads_package_dunder', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413733, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataVersion', 'test_version_fallback_unknown_when_no_dunder', 0.02, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413734, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsFwhmMapping', 'test_fwhm_major_list_of_tuples_maps_to_sigma_x_per_component', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413735, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsFwhmMapping', 'test_fwhm_minor_single_tuple_maps_to_sigma_y_tuple', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413736, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesFwhmMinorMappingPublicAPI', 'test_components_list_of_dicts_maps_fwhm_minor_to_sigma_y_in_p0', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413737, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAutoSeedingPixelPublicAPI', 'test_auto_seed_pixel_public_api', 0.043, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413738, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAutoSeedingPixelElsePublicAPI', 'test_auto_seeding_pixel_else_path_public_api', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413739, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataShortener', 'test_coords_repr_truncated_when_shape_property_raises', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413740, 303023617039413666, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestWorldSeeding', 'test_autoseed_uses_world_axes_and_recovers_params', 0.186, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413741, 303023617039413666, 'tests.unit.distributed.imaging.test_feather.FeatherTest', 'test_feather', 28.958, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413742, 303023617039413666, 'tests.unit.distributed.imaging.test_feather.FeatherTest', 'test_overwrite', 1.338, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413743, 303023617039413666, 'tests.unit.distributed.imaging.test_feather.FeatherModelComparison', 'test_basic_stats_and_positions', 9.972, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413744, 303023617039413666, 'tests.unit.distributed.imaging.test_feather.FeatherModelComparison', 'test_center_region_and_width_inference', 0.466, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413745, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_auto_uses_math_on_right_handed_grid', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413746, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_auto_uses_pa_on_left_handed_grid', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413747, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_degrees_flag', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413748, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_add_false_replaces_inside', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413749, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_add_true_adds_only_inside', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413750, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_output_kinds_numpy_and_dask', 0.088, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413751, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_param_validation', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413752, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_add_true_adds_gaussian', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413753, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_decreasing_x_coords_ok', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413754, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_output_kinds', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413755, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_peak_at_center_replacement', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413756, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_add_true_adds_to_existing', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413757, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_midpoint_tie_chooses_right', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413758, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_output_kinds_numpy_and_dask', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413759, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_requires_equal_lengths', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413760, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_sum_duplicates', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413761, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_length_mismatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413762, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_missing_coord_keys', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413763, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_rejects_non_2d_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413764, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_rejects_unsupported_type', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413765, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_requires_coords_for_raw_arrays', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413766, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_non_monotonic_x_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413767, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_non_monotonic_y_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413768, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_requires_len_ge_2', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413769, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_clip_clamps', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413770, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_error_policy_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413771, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_ignore_returns_mask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413772, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_ignore_sloppy_keeps_half_pixel', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413773, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutput', 'test_invalid_output_kind_raises', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413774, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestParamValidation', 'test_make_disk_param_validation', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413775, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestParamValidation', 'test_make_gauss2d_param_validation', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413776, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_length_at_least_one', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413777, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_must_be_1d', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413778, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_strictly_monotonic', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413779, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_descending_branch_maps_back', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413780, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_invalid_out_of_range_value_raises', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413781, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_dask_to_numpy_compute_line', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413782, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_dask', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413783, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_dataarray', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413784, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_numpy', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413785, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_numpy_to_dask_wrap_line', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413786, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_clip_with_mask_size_one', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413787, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_ignore_plain_return_no_mask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413788, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_ignore_sloppy_size_one_validity', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (303023617039413789, 303023617039413666, 'tests.unit.distributed.model.test_component_models.TestMakePtSourcesEarlyExit', 'test_all_out_of_range_early_exit', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);