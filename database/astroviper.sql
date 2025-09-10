-- CREATE TABLE statements

-- Test Suites Table
CREATE TABLE IF NOT EXISTS test_suites (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    component VARCHAR(255) NOT NULL,
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
INSERT OR IGNORE INTO test_suites (id, name, component, tests, failures, errors, skipped, time, timestamp, hostname) 
VALUES (225774281675799091, 'pytest', '''{component}''', 193, 
        0, 0, 0, 48.694, 
        '2025-09-10T18:13:28.359269+00:00', 'runnervmf4ws1');

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799092, 225774281675799091, 'tests.unit.core.imaging.test_fft_ifft.FFTTest', 'test_fft_ifft_round_trip', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799093, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_two_components_with_world_coords[0.02]', 0.891, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799094, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_two_components_with_world_coords[0.05]', 0.904, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799095, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_vectorize_over_time_names_and_indices', 0.137, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799096, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_flags_and_descending_world_coords', 0.078, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799097, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestSuccess', 'test_auto_seeds_when_initial_none', 0.043, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799098, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_accepts_raw_numpy_array', 0.026, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799099, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_accepts_bare_dask_array', 0.13, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799100, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInputs', 'test_world_coords_skipped_for_bad_axis_coords', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799101, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_bounds_merge_tuple_all_and_unknown_key_ignored', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799102, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_bounds_merge_per_component_length_error', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799103, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_dims_by_index_and_error_paths', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799104, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsDimsAPI', 'test_init_formats_and_errors', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799105, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_full_mask_triggers_failure_and_nan_planes', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799106, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_exception_sets_failure', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799107, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_pcov_none_sets_errors_nan', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799108, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_with_valid_pcov_sets_finite_errors', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799109, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_nonfinite_popt_triggers_not_success_nan_outputs', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799110, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestOptimizerFailures', 'test_curve_fit_pcov_wrong_shape_sets_errors_nan_success_true', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799111, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesTopLevelListOfDicts', 'test_top_level_list_of_dicts_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799112, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesTopLevelListOfDicts', 'test_top_level_list_of_dicts_happy_path_parses_and_packs', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799113, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesPublicAPIWrapping', 'test_single_dict_shorthand_is_wrapped_and_used', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799114, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_3d_with_indexer_and_no_component_dim', 0.084, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799115, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_defaults_indexer_for_3d_input', 0.049, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799116, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_selects_result_plane_with_default_indexer', 0.057, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799117, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_default_indexer_loops_multiple_dims', 0.068, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799118, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_else_branch_for_2d_input', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799119, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_raises_when_result_missing_required_var', 0.031, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799120, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_fwhm_converts_from_sigma_when_fwhm_missing', 0.03, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799121, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_plot_components_fwhm_warns_and_draws_without_size_when_both_missing', 0.033, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799122, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestPlotHelper', 'test_overlay_converts_fwhm_to_sigma_when_sigma_missing', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799123, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_min_threshold_masks_pixels_partial', 0.022, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799124, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_max_threshold_masks_pixels_partial', 0.026, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799125, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_conversion_and_reporting', 0.028, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799126, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_conversion_list_of_dicts', 0.047, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799127, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_array_dict_converted', 0.026, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799128, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_list_of_dicts_converted', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799129, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_list_of_dicts_missing_theta_covers_if_false_branch', 0.037, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799130, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_angle_pa_init_components_list_of_dicts_branch', 0.043, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799131, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_plot_components_uses_model_branch_and_slices_leading_dims', 0.039, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799132, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_pixel_fit_interpolates_world_centers_and_propagates_errors_ascending', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799133, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestNumPyFitting', 'test_pixel_fit_interpolates_world_centers_descending_x', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799134, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_array_wrong_shape_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799135, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799136, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_happy_path_synonyms_and_theta_default', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799137, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_missing_keys_raise', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799138, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_list_happy_path_covers_224_232', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799139, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_tuple_len_mismatch_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799140, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_components_tuple_happy_path_covers_224_to_232', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799141, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_array_list_form_fallback_covers_234_235', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799142, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_bounds_offset_branch_public_api', 0.025, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799143, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_bounds_per_component_list_public_api_hits_comp_idx_branch', 0.057, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799144, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_public_api_ensure_dataarray_raises_on_unsupported_type', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799145, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_resolve_dims_raises_for_3d_without_dims', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799146, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_public_api_n_components_must_be_positive', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799147, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_initial_guesses_list_of_dicts_wrong_length_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799148, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAPIHelpers', 'test_init_array_wrong_shape_hits_conv_arr_early_return_then_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799149, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestMetadataNotes', 'test_variance_explained_includes_self_documenting_note', 0.023, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799150, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_canonicalization_swaps_axes_and_rotates_theta_by_half_pi', 0.024, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799151, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_canonicalization_wraps_theta_into_half_pi_interval', 0.047, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799152, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAngleEndToEndFitter', 'test_theta_math_pa_relation_pixel_right_and_left_handed', 0.297, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799153, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInnerPrepCoverage', 'test_inner_prep_lines_executed', 0.015, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799154, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_coords_validation_and_success', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799155, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_numpy_input_coords_tuple_happy_path_returns_y1d_x1d', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799156, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestCoordsForNdarrayInput', 'test_numpy_input_coords_tuple_wrong_lengths_raise', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799157, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataVersion', 'test_version_fallback_reads_package_dunder', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799158, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataVersion', 'test_version_fallback_unknown_when_no_dunder', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799159, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsFwhmMapping', 'test_fwhm_major_list_of_tuples_maps_to_sigma_x_per_component', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799160, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestBoundsFwhmMapping', 'test_fwhm_minor_single_tuple_maps_to_sigma_y_tuple', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799161, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestInitialGuessesFwhmMinorMappingPublicAPI', 'test_components_list_of_dicts_maps_fwhm_minor_to_sigma_y_in_p0', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799162, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAutoSeedingPixelPublicAPI', 'test_auto_seed_pixel_public_api', 0.042, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799163, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestAutoSeedingPixelElsePublicAPI', 'test_auto_seeding_pixel_else_path_public_api', 0.017, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799164, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestResultMetadataShortener', 'test_coords_repr_truncated_when_shape_property_raises', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799165, 225774281675799091, 'tests.unit.distributed.image_analysis.test_multi_gaussian2d_fit.TestWorldSeeding', 'test_autoseed_uses_world_axes_and_recovers_params', 0.181, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799166, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_box_with_and_without_header_0based_and_area', 0.036, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799167, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_circle_centroid_near_center', 0.049, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799168, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_rotbox_ellipse_parse_and_nonempty[rotbox-rotbox[[120pix,80pix],[60pix,30pix], theta_m=30]]', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799169, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFBasics', 'test_rotbox_ellipse_parse_and_nonempty[ellipse-ellipse[[120pix,80pix],[50pix,25pix], theta_m=60]]', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799170, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFCombine', 'test_multi_line_plus_minus_matches_boolean_ops', 0.065, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799171, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_roi_and_not_bad', 0.04, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799172, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_invalid_minus_not_raises', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799173, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_unknown_name_keyerror_lists_available', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799174, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_syntax_error_raises_value_error', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799175, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_with_xarray_dataset_mask_source', 0.032, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799176, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_mask_source_typeerror_when_not_mapping_or_dataset', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799177, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_mask_source_empty_raises_value_error', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799178, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_unsupported_construct_compare_raises', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799179, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_boolop_and_or_forbidden_raises', 0.017, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799180, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_bitwise_and_or_xor_return_paths', 0.006, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799181, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestExpressions', 'test_expression_constant_true_false_returns_bool_arrays', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799182, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestToBoolCasting', 'test_numeric_masks_nan_to_false_and_casting', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799183, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_backticked_file_and_path_object_match_inline', 0.087, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799184, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_missing_backticked_file_raises_file_not_found', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799185, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_missing_path_object_raises_file_not_found', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799186, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_plain_string_not_backticked_is_parsed_as_text_via_public_api', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799187, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFFile', 'test_non_string_non_path_select_raises_typeerror_public_api', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799188, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestErrorMessages', 'test_box_without_pix_suggests_pix_units', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799189, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestErrorMessages', 'test_centerbox_without_pix_in_sizes_suggests_pix_units', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799190, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestUnsupportedSelectType', 'test_unsupported_select_type_typeerror_message', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799191, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestApplySelect', 'test_apply_select_sets_outside_to_nan', 0.034, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799192, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestApplySelect', 'test_full_image_box_selects_all_pixels', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799193, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestApplySelect', 'test_apply_select_numpy_branch_sets_outside_nan_preserves_inside', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799194, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_convex_square_membership_and_invariance', 0.159, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799195, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_concave_arrow_shape_includes_and_excludes_expected_points', 0.123, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799196, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_polygon_with_float_vertices_behaves_sensibly', 0.064, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799197, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestPolygon', 'test_polygon_file_roundtrip_matches_inline', 0.065, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799198, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestNumpyMaskAlignment', 'test_numpy_float_mask_nan_to_false_and_broadcast', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799199, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestNumpyMaskAlignment', 'test_numpy_mask_broadcast_error_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799200, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestAllTrueMaskLike', 'test_none_select_numpy_returns_all_true', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799201, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestAllTrueMaskLike', 'test_none_select_xarray_returns_all_true', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799202, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestSmartSplitPairs', 'test_annulus_equals_circle_diff_and_trims_trailing_space', 0.045, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799203, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestXarrayMaskAlignment', 'test_xarray_float_mask_with_nan_fillna_false', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799204, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_numpy_from_expression', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799205, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_from_crtf', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799206, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dataarray_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799207, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dataarray_dask_and_apply_select', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799208, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_wrap_numpy_mask_to_dask_dataarray', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799209, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dataarray_numpy_from_numpy_mask_numpy_data_hits_else_branch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799210, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dataarray_numpy_from_xarray_dask_mask_xarray_data_computes', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799211, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_from_xarray_dask_mask_returns_dask_array', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799212, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_wraps_xarray_numpy_mask_using_inferred_or_given_chunks', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799213, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_return_kind_dask_wraps_numpy_mask_when_data_is_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799214, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dask_return_kind_infers_chunks_from_data_success', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799215, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dask_return_kind_infer_chunks_exception_path_without_monkeypatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799216, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestReturnKinds', 'test_dataarray_numpy_else_branch_creation_attached_and_printed', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799217, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFDirectives', 'test_global_directive_lines_are_ignored', 0.025, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799218, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCreationAutoMerge', 'test_auto_merge_creation_from_triplet_attrs', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799219, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCreationAutoMerge', 'test_auto_merge_creation_falls_back_to_single_creation_attr', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799220, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestAlignFallback', 'test_broadcast_like_exception_fallback_numpy_wrap_success', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799221, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestAlignFallback', 'test_fallback_broadcast_to_failure_raises_valueerror', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799222, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_invalid_op_raises', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799223, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_or_and_xor_semantics_and_creation_merge_default', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799224, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_creation_hint_overrides', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799225, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_template_controls_dims_and_return_kind_numpy', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799226, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationAPI', 'test_dask_chunks_applied_when_requesting_dask_return_kind', 0.006, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799227, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestDataArrayMaskConstructorFallback', 'test_dims_constructor_raises_and_fallback_without_dims_used', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799228, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationRenameExcept', 'test_template_rename_exception_path_falls_back_and_succeeds', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799229, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestToBoolDataArray', 'test_dataarray_float_nan_fillna_before_bool', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799230, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFMalformed', 'test_crtf_invalid_line_raises', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799231, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFNumericParsingErrors', 'test_invalid_numeric_token_in_angle_raises_value_error', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799232, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFNumericParsingErrors', 'test_invalid_pixel_quantity_token_raises_specific_message', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799233, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCreationAssignmentInDataArrayNumpyReturn', 'test_creation_hint_attached_in_dataarray_numpy_else_branch', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799234, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCombineWithCreationRenameDoubleExcept', 'test_rename_and_constructor_fallback_both_raise_then_pass', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799235, 225774281675799091, 'tests.unit.distributed.image_analysis.test_selection.TestCRTFPA', 'test_rotbox_pa_equivalent_to_theta_m', 0.157, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799236, 225774281675799091, 'tests.unit.distributed.imaging.test_feather.FeatherTest', 'test_feather', 25.845, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799237, 225774281675799091, 'tests.unit.distributed.imaging.test_feather.FeatherTest', 'test_overwrite', 1.086, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799238, 225774281675799091, 'tests.unit.distributed.imaging.test_feather.FeatherModelComparison', 'test_basic_stats_and_positions', 9.585, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799239, 225774281675799091, 'tests.unit.distributed.imaging.test_feather.FeatherModelComparison', 'test_center_region_and_width_inference', 0.404, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799240, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_auto_uses_math_on_right_handed_grid', 0.012, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799241, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_auto_uses_pa_on_left_handed_grid', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799242, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestAngleModes', 'test_degrees_flag', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799243, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_add_false_replaces_inside', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799244, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_add_true_adds_only_inside', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799245, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_output_kinds_numpy_and_dask', 0.082, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799246, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeDisk', 'test_param_validation', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799247, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_add_true_adds_gaussian', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799248, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_decreasing_x_coords_ok', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799249, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_output_kinds', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799250, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakeGauss2D', 'test_peak_at_center_replacement', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799251, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_add_true_adds_to_existing', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799252, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_midpoint_tie_chooses_right', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799253, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_output_kinds_numpy_and_dask', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799254, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_requires_equal_lengths', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799255, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakePtSources', 'test_sum_duplicates', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799256, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_length_mismatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799257, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_missing_coord_keys', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799258, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_rejects_non_2d_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799259, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_rejects_unsupported_type', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799260, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestCoerceToXda', 'test_requires_coords_for_raw_arrays', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799261, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_non_monotonic_x_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799262, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_non_monotonic_y_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799263, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestInferHandedness', 'test_requires_len_ge_2', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799264, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_clip_clamps', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799265, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_error_policy_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799266, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_ignore_returns_mask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799267, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestOutOfRangePolicies', 'test_ignore_sloppy_keeps_half_pixel', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799268, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutput', 'test_invalid_output_kind_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799269, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestParamValidation', 'test_make_disk_param_validation', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799270, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestParamValidation', 'test_make_gauss2d_param_validation', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799271, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_length_at_least_one', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799272, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_must_be_1d', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799273, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_coord_vals_strictly_monotonic', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799274, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_descending_branch_maps_back', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799275, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesEdgeCases', 'test_invalid_out_of_range_value_raises', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799276, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_dask_to_numpy_compute_line', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799277, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_dask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799278, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_dataarray', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799279, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_match_with_numpy', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799280, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestFinalizeOutputMatchDispatch', 'test_numpy_to_dask_wrap_line', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799281, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_clip_with_mask_size_one', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799282, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_ignore_plain_return_no_mask', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799283, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestNearestIndicesSizeOneCompletion', 'test_ignore_sloppy_size_one_validity', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (225774281675799284, 225774281675799091, 'tests.unit.distributed.model.test_component_models.TestMakePtSourcesEarlyExit', 'test_all_out_of_range_early_exit', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);