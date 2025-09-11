-- CREATE TABLE statements

-- Test Suites Table
CREATE TABLE IF NOT EXISTS test_suites (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    component VARCHAR(255) NOT NULL,
    runid VARCHAR(255) NOT NULL,
    runnumber VARCHAR(255) NOT NULL,
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
INSERT OR IGNORE INTO test_suites (id, name, component, runid, runnumber, branch, tests, failures, errors, skipped, time, timestamp, hostname) 
VALUES (242998359672049998, 'pytest', 'xradio',
'17649799096','15',
 '23-grafana-dashboard', 352, 
        0, 0, 0, 85.641, 
        '2025-09-11T15:43:40.722621+00:00', 'runnervmf4ws1');

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672049999, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_get_img_ds_block', 3.29, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050000, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_uv_image', 0.167, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050001, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_attrs', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050002, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_beam_param_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050003, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_frequency_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050004, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_l_m_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050005, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_no_sky', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050006, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_pixel_values', 0.158, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050007, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_polarization_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050008, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_ra_dec_axis', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050009, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_time_axis', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050010, 242998359672049998, 'tests.unit.image.test_image.casa_image_to_xds_test', 'test_xds_vel_axis', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050011, 242998359672049998, 'tests.unit.image.test_image.xds_to_casacore', 'test_object_name_not_present', 0.43, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050012, 242998359672049998, 'tests.unit.image.test_image.xds_to_casacore', 'test_writing_numpy_array_as_data_var', 0.216, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050013, 242998359672049998, 'tests.unit.image.test_image.casacore_to_xds_to_casacore', 'test_beam', 1.911, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050014, 242998359672049998, 'tests.unit.image.test_image.casacore_to_xds_to_casacore', 'test_masking', 1.964, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050015, 242998359672049998, 'tests.unit.image.test_image.casacore_to_xds_to_casacore', 'test_metadata', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050016, 242998359672049998, 'tests.unit.image.test_image.casacore_to_xds_to_casacore', 'test_output_uv_casa_image', 0.266, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050017, 242998359672049998, 'tests.unit.image.test_image.casacore_to_xds_to_casacore', 'test_pixels_and_mask', 0.028, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050018, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_beam', 0.716, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050019, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_get_img_ds_block', 0.295, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050020, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_output_uv_zarr_image', 0.242, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050021, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_attrs', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050022, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_frequency_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050023, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_l_m_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050024, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_pixel_values', 0.145, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050025, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_polarization_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050026, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_ra_dec_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050027, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_time_vals', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050028, 242998359672049998, 'tests.unit.image.test_image.xds_to_zarr_to_xds_test', 'test_xds_vel_axis', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050029, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_bscale_guard', 0.356, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050030, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_bzero_guard', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050031, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_compressed_fits_guard', 0.147, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050032, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_compute_mask', 0.06, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050033, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_multibeam', 0.809, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050034, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_attrs', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050035, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_beam_param_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050036, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_frequency_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050037, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_l_m_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050038, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_pixel_values', 0.274, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050039, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_polarization_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050040, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_ra_dec_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050041, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_time_axis', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050042, 242998359672049998, 'tests.unit.image.test_image.fits_to_xds_test', 'test_xds_vel_axis', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050043, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_attrs', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050044, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_declination_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050045, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_dims_and_coords', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050046, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_frequency_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050047, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_l_m_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050048, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_polarization_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050049, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_right_ascension_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050050, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_time_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050051, 242998359672049998, 'tests.unit.image.test_image.make_empty_sky_image_tests', 'test_vel_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050052, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_attrs', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050053, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_dims_and_coords', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050054, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_frequency_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050055, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_polarization_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050056, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_time_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050057, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_u_v_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050058, 242998359672049998, 'tests.unit.image.test_image.make_empty_aperture_image_tests', 'test_vel_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050059, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_attrs', 0.019, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050060, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_declination_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050061, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_dims', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050062, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_frequency_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050063, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_l_m_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050064, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_polarization_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050065, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_right_ascension_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050066, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_time_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050067, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_u_v_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050068, 242998359672049998, 'tests.unit.image.test_image.make_empty_lmuv_image_tests', 'test_vel_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050069, 242998359672049998, 'tests.unit.image.test_image.write_image_test', 'test_overwrite', 1.053, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050070, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_exists[ms_minimal_required-True]', 0.093, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050071, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_exists[ms_tab_nonexistent-False]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050072, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_exists[generic_antenna_xds_min-False]', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050073, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column[ms_minimal_required-TIME-True]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050074, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column[ms_minimal_required-WEIGHT_SPECTRUM-False]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050075, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column[ms_minimal_required-WEIGHT-True]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050076, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column[ms_minimal_required-DATA-True]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050077, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column[ms_minimal_required-TIME_CENTROID-True]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050078, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column[ms_minimal_required-FOO_INEXISTENT-False]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050079, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column_raises[ms_tab_nonexistent-DATA-expected_raises0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050080, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column_raises[ms_tab_nonexistent-ANY-expected_raises1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050081, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column_raises[generic_antenna_xds_min-TIME-expected_raises2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050082, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_table_has_column_raises[generic_source_xds_min-ANTENNA1-expected_raises3]', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050083, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times0-True-expected_result0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050084, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times1-True-expected_result1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050085, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times2-True-expected_result2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050086, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times3-True-expected_result3]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050087, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times4-False-expected_result4]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050088, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times5-False-expected_result5]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050089, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times6-False-expected_result6]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050090, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time[times7-False-expected_result7]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050091, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_mjd_time[times0-expected_result0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050092, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_mjd_time[times1-expected_result1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050093, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_mjd_time[times2-expected_result2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050094, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time_to_mjd[times0-expected_result0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050095, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_convert_casacore_time_to_mjd[times1-expected_result1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050096, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_extract_table_attributes_main', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050097, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_table[in_min_max0-expected_result0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050098, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_table[in_min_max1-expected_result1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050099, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max0-in_array0-expected_result0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050100, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max1-in_array1-expected_result1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050101, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max2-in_array2-expected_result2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050102, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max3-in_array3-expected_result3]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050103, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max4-in_array4-expected_result4]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050104, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max5-in_array5-expected_result5]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050105, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max6-in_array6-expected_result6]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050106, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max7-in_array7-expected_result7]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050107, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max8-in_array8-expected_result8]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050108, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max9-in_array9-expected_result9]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050109, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max10-in_array10-expected_result10]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050110, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max11-in_array11-expected_result11]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050111, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max12-in_array12-expected_result12]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050112, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max13-in_array13-expected_result13]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050113, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_find_projected_min_max_array[in_min_max14-in_array14-expected_result14]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050114, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_make_taql_where_between_min_max_empty', 0.029, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050115, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_make_taql_where_between_min_max[in_min_max0-where TIME >= -8.881784197001252e-16 AND TIME <= 2000000000.0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050116, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_make_taql_where_between_min_max[in_min_max1-where TIME >= -8.881784197001252e-16 AND TIME <= 3000000000.0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050117, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_extract_table_attributes_ant', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050118, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_add_units_measures', 0.745, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050119, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_add_units_measures_dubious_units', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050120, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_get_pad_value_in_tablerow_column', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050121, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_get_pad_value_uvw', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050122, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_get_pad_value_n_polynomial', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050123, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_get_pad_value_baseline_id', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050124, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_redimension_ms_subtable_source', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050125, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_redimension_ms_subtable_phase_cal', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050126, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_is_ephem_subtable_ms', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050127, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_add_ephemeris_vars', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050128, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_is_nested_ms_empty', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050129, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_is_nested_ms_ant', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050130, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_is_nested_ms_ms_min', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050131, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_antenna', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050132, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_feed', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050133, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_polarization', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050134, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_source[ms_minimal_required-expected_additional_columns0]', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050135, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_source[ms_minimal_misbehaved-expected_additional_columns1]', 0.081, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050136, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_state', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050137, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_pointing', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050138, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_ephem', 0.01, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050139, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_table_weather', 0.02, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050140, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_cols_state', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050141, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_load_generic_cols_spw', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050142, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_read_flat_col_chunk_time', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050143, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_read_flat_col_chunk_sigma', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050144, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_read_flat_col_chunk_flag', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050145, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read', 'test_read_col_conversion_dask', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050146, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[-expected_output0]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050147, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID = 0 AND SCAN_NUMBER = 1 AND STATE_ID = 0-expected_output1]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050148, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID IN [0,1] AND SCAN_NUMBER = 1 AND STATE_ID = 0-expected_output2]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050149, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID IN [0,1,2] AND SCAN_NUMBER = 1 AND STATE_ID = 0-expected_output3]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050150, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID IN [0,1,2,3] AND SCAN_NUMBER = 1 AND STATE_ID = 0-expected_output4]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050151, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID IN [0,1,2,3,4] AND SCAN_NUMBER = 1 AND STATE_ID = 0-expected_output5]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050152, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID = 0 AND SCAN_NUMBER = 1 AND STATE_ID = 1-expected_output6]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050153, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_utimes_tol[where DATA_DESC_ID IN [0,1] AND SCAN_NUMBER = 1 AND STATE_ID = 1-expected_output7]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050154, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baselines[ms_empty_required-expected_output0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050155, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baselines[ms_minimal_required-expected_output1]', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050156, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baselines[ms_minimal_without_opt-expected_output2]', 0.057, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050157, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baselines_custom[ms_custom_spec0]', 0.081, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050158, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_custom[ms_custom_spec0]', 0.902, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050159, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baseline_indices[unique_baselines0-baselines0-expected_output0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050160, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baseline_indices[unique_baselines1-baselines1-expected_output1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050161, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baseline_indices[unique_baselines2-baselines2-expected_output2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050162, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baseline_indices[unique_baselines3-baselines3-expected_output3]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050163, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baseline_indices[unique_baselines4-baselines4-expected_output4]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050164, 242998359672049998, 'tests.unit.measurement_set._utils._msv2._tables.test_read_main_table', 'test_get_baseline_indices[unique_baselines5-baselines5-expected_output5]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050165, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[input_chunksize0-main-None-expected_chunksize0-expected_error0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050166, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[input_chunksize1-pointing-None-expected_chunksize1-expected_error1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050167, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[input_chunksize2-main-xds2-expected_chunksize2-expected_error2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050168, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[input_chunksize3-main-xds3-expected_chunksize3-expected_error3]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050169, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[0.02-main-xds4-expected_chunksize4-expected_error4]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050170, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[wrong_input_chunksize-main-xds5-None-expected_error5]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050171, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[0.01-main-xds6-expected_chunksize6-expected_error6]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050172, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[0.01-main-xds7-None-expected_error7]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050173, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_parse_chunksize[0.0002-pointing-xds8-expected_chunksize8-expected_error8]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050174, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_check_chunksize[chunksize0-main-expectation0]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050175, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_check_chunksize[chunksize1-pointing-expectation1]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050176, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_check_chunksize[chunksize2-main-expectation2]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050177, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_check_chunksize[chunksize3-pointing-expectation3]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050178, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_check_chunksize[chunksize4-main-expectation4]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050179, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_check_chunksize[chunksize5-pointing-expectation5]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050180, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict[pseudo_xds0-main-expected_chunksize0-expected_error0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050181, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict[pseudo_xds1-bar_wrong-expected_chunksize1-expected_error1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050182, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main[1e-09-pseudo_xds0-expected_chunksize0-expected_error0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050183, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main[0.9-pseudo_xds1-expected_chunksize1-expected_error1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050184, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main[0.01-pseudo_xds2-expected_chunksize2-expected_error2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050185, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main[0.01-pseudo_xds3-None-expected_error3]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050186, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main_balanced[0.001-dim_sizes0-expected_chunksize0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050187, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main_balanced[0.02-dim_sizes1-expected_chunksize1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050188, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main_balanced[0.03-dim_sizes2-expected_chunksize2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050189, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_main_balanced[0.05-dim_sizes3-expected_chunksize3]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050190, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_pointing[0.1-dim_sizes0-expected_chunksize0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050191, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_pointing[0.5-dim_sizes1-expected_chunksize1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050192, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_mem_chunksize_to_dict_pointing[0.5-dim_sizes2-expected_chunksize2]', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050193, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_itemsize_spec', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050194, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_itemsize_pointing_spec', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050195, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_calc_used_gb', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050196, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_estimate_memory_and_cores_for_partitions[test_ms_minimal_required.ms-partitions0-expected_estimate0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050197, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_empty_complete', 0.039, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050198, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_empty_required', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050199, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_min', 0.522, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050200, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_misbehaved', 0.308, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050201, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_with_antenna1', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050202, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_conversion', 'test_convert_and_write_partition_without_opt', 0.267, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050203, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_empty', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050204, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_minimal_wrong_antenna_ids', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050205, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_minimal_wrong_feed_ids', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050206, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_minimal', 0.028, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050207, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_minimal_other_telescope', 0.027, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050208, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_misbehaved', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050209, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_antenna_xds', 'test_create_antenna_xds_without_opt', 0.029, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050210, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_field_and_source_xds', 'test_create_field_and_source_xds_empty', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050211, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_field_and_source_xds', 'test_create_field_and_source_xds_minimal_wrong_field_ids', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050212, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_field_and_source_xds', 'test_create_field_and_source_xds_minimal', 0.076, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050213, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_field_and_source_xds', 'test_create_field_and_source_xds_misbehaved', 0.025, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050214, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_field_and_source_xds', 'test_create_field_and_source_xds_without_opt', 0.057, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050215, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_create_field_and_source_xds', 'test_pad_missing_sources', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050216, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_info_dicts', 'test_create_info_dicts_empty', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050217, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_info_dicts', 'test_create_info_dicts', 0.013, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050218, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_rename_and_interpolate_to_time_with_none_time', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050219, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_rename_and_interpolate_to_time_with_syscal_none_time', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050220, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_rename_and_interpolate_to_time_bogus', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050221, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_rename_and_interpoalte_to_time_main', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050222, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_weather_xds_empty_ant_ids', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050223, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_weather_xds_empty', 0.033, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050224, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_weather_xds_min', 0.038, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050225, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_weather_xds_misbehaved', 0.034, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050226, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_weather_xds_ms_without_opt_subtables', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050227, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_pointing_xds_empty_ant_ids', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050228, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_pointing_xds_empty', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050229, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_pointing_xds_empty_time_interp', 0.003, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050230, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_pointing_xds_min_time_interp', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050231, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_pointing_xds_without_opt', 0.018, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050232, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_system_calibration_xds_empty', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050233, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_system_calibration_xds_min', 0.032, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050234, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_msv4_sub_xdss', 'test_create_system_calibration_xds_without_opt', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050235, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_optimised_functions', 'test_unique_1d[input_array0-expected_unique_array0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050236, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_optimised_functions', 'test_unique_1d[input_array1-expected_unique_array1]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050237, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_optimised_functions', 'test_unique_1d[input_array2-expected_unique_array2]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050238, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_optimised_functions', 'test_pairing_function', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050239, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_optimised_functions', 'test_inverse_pairing_function', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050240, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_partitions_ms_empty', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050241, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_paritions_ms_min', 0.023, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050242, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_partitions_ms_min_with_field', 0.023, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050243, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_partitions_ms_min_with_antenna1', 0.067, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050244, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_partitions_ms_min_with_state_id', 0.023, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050245, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_partitions_ms_min_with_all', 0.084, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050246, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_partition_queries', 'test_create_partitions_ms_min_with_other', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050247, 242998359672049998, 'tests.unit.measurement_set._utils._msv2.test_subtables', 'test_subtables_subt_rename_ids', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050248, 242998359672049998, 'tests.unit.measurement_set._utils._utils.test_interpolate', 'test_interpolate_to_time_bogus', 0.005, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050249, 242998359672049998, 'tests.unit.measurement_set._utils._utils.test_interpolate', 'test_interpolate_to_time_main', 0.016, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050250, 242998359672049998, 'tests.unit.measurement_set._utils._utils.test_stokes_types', 'test_stokes_types', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050251, 242998359672049998, 'tests.unit.measurement_set._utils._zarr.test_encoding', 'test_add_encoding_wo_chunks', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050252, 242998359672049998, 'tests.unit.measurement_set._utils._zarr.test_encoding', 'test_add_encoding_with_wrong_chunks', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050253, 242998359672049998, 'tests.unit.measurement_set._utils._zarr.test_encoding', 'test_add_encoding_with_chunks', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050254, 242998359672049998, 'tests.unit.measurement_set.test_convert_msv2_to_processing_set', 'test_estimate_conversion_memory_and_cores_minimal[ms_minimal_required-partition_scheme0-expected_estimation0]', 0.034, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050255, 242998359672049998, 'tests.unit.measurement_set.test_convert_msv2_to_processing_set', 'test_estimate_conversion_memory_and_cores_minimal[ms_minimal_required-partition_scheme1-expected_estimation1]', 0.034, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050256, 242998359672049998, 'tests.unit.measurement_set.test_convert_msv2_to_processing_set', 'test_estimate_conversion_memory_and_cores_minimal[ms_minimal_required-partition_scheme2-expected_estimation2]', 0.035, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050257, 242998359672049998, 'tests.unit.measurement_set.test_convert_msv2_to_processing_set', 'test_estimate_conversion_memory_and_cores_with_errors[inexistent_foo_path_.mms-expected_error0]', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050258, 242998359672049998, 'tests.unit.measurement_set.test_convert_msv2_to_processing_set', 'test_convert_msv2_to_processing_set_with_other_opts', 1.27, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050259, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestLoadProcessingSet', 'test_check_datatree[Antennae_North.cal.lsrk.split.ms]', 1.243, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050260, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestLoadProcessingSet', 'test_basic_load[Antennae_North.cal.lsrk.split.ms]', 1.21, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050261, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestLoadProcessingSet', 'test_selective_loading[Antennae_North.cal.lsrk.split.ms]', 1.249, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050262, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestLoadProcessingSet', 'test_data_group_selection[Antennae_North.cal.lsrk.split.ms]', 1.237, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050263, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestLoadProcessingSet', 'test_variable_selection[Antennae_North.cal.lsrk.split.ms]', 1.392, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050264, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestLoadProcessingSet', 'test_sub_datasets[Antennae_North.cal.lsrk.split.ms]', 1.323, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050265, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestProcessingSetIterator', 'test_iterator_with_store[Antennae_North.cal.lsrk.split.ms]', 1.254, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050266, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestProcessingSetIterator', 'test_iterator_with_memory[Antennae_North.cal.lsrk.split.ms]', 1.238, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050267, 242998359672049998, 'tests.unit.measurement_set.test_load_processing_set.TestProcessingSetIterator', 'test_iterator_with_data_groups[Antennae_North.cal.lsrk.split.ms]', 1.257, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050268, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_sel_invalid', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050269, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_field_and_source_xds_invalid', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050270, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_partition_info', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050271, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_add_data_group_with_defaults', 0.015, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050272, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_add_data_group_with_values', 0.014, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050273, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_field_and_source_xds', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050274, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_field_and_source_xds_with_group', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050275, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_partition_info_default', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050276, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_partition_info_with_group_wrong', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050277, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_get_partition_info_with_group', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050278, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_sel_with_data_group_missing', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050279, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_sel_with_data_group', 0.008, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050280, 242998359672049998, 'tests.unit.measurement_set.test_measurement_set_xdt', 'test_sel_polarization', 0.021, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050281, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_summary_empty', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050282, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_get_max_dims_empty', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050283, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_get_freq_axis_empty', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050284, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_query_empty', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050285, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_get_combined_antenna', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050286, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_get_combined_field_and_source_xds_empty', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050287, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_get_combined_field_and_source_xds_ephemeris_empty', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050288, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_plot_phase_centers_empty', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050289, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtErrors', 'test_plot_antenna_positions', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050290, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithData', 'test_summary[Antennae_North.cal.lsrk.split.ms]', 1.229, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050291, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithData', 'test_get_max_dims[Antennae_North.cal.lsrk.split.ms]', 1.21, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050292, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithData', 'test_get_freq_axis[Antennae_North.cal.lsrk.split.ms]', 1.214, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050293, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithData', 'test_query[Antennae_North.cal.lsrk.split.ms]', 1.248, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050294, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithData', 'test_get_combined_field_and_source_xds[Antennae_North.cal.lsrk.split.ms]', 1.233, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050295, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithEphemerisData', 'test_check_ephemeris_datatree[ALMA_uid___A002_X1003af4_X75a3.split.avg.ms]', 11.435, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050296, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithEphemerisData', 'test_get_combined_field_and_source_xds_ephemeris[ALMA_uid___A002_X1003af4_X75a3.split.avg.ms]', 11.637, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050297, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithEphemerisData', 'test_field_offset_calculation[ALMA_uid___A002_X1003af4_X75a3.split.avg.ms]', 11.561, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050298, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestProcessingSetXdtWithEphemerisData', 'test_time_interpolation[ALMA_uid___A002_X1003af4_X75a3.split.avg.ms]', 11.43, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050299, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestFunctionsAfterPreviousCalls', 'test_query_after_query_corrected[processing_set_from_custom_ms0]', 0.619, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050300, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestFunctionsAfterPreviousCalls', 'test_repeated_get_max_dims[processing_set_from_custom_ms0]', 0.071, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050301, 242998359672049998, 'tests.unit.measurement_set.test_processing_set_xdt.TestFunctionsAfterPreviousCalls', 'test_repeated_get_freq_axis[processing_set_from_custom_ms0]', 0.077, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050302, 242998359672049998, 'tests.unit.schema.test_export', 'test_schema_export_in_synch[VisibilityXds]', 0.011, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050303, 242998359672049998, 'tests.unit.schema.test_export', 'test_schema_export_in_synch[SpectrumXds]', 0.009, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050304, 242998359672049998, 'tests.unit.schema.test_schema', 'test_xarray_dataclass_to_array_schema', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050305, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050306, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_dask', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050307, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_array_style', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050308, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_dataclass_style', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050309, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_from_dataarray', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050310, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_from_dataarray_override', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050311, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_auto_coords', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050312, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_list', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050313, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_defaults', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050314, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_constructor_mixed', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050315, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_dtype_mismatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050316, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_dtype_mismatch_constructor', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050317, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_dtype_mismatch_expect', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050318, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_extra_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050319, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_missing_coord', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050320, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_wrong_coord', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050321, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_missing_attr', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050322, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_extra_attr', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050323, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_optional_attr', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050324, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_array_wrong_type', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050325, 242998359672049998, 'tests.unit.schema.test_schema', 'test_schema_checked_wrap', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050326, 242998359672049998, 'tests.unit.schema.test_schema', 'test_schema_checked_no_annotation', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050327, 242998359672049998, 'tests.unit.schema.test_schema', 'test_schema_checked_annotation', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050328, 242998359672049998, 'tests.unit.schema.test_schema', 'test_schema_checked_annotation_optional', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050329, 242998359672049998, 'tests.unit.schema.test_schema', 'test_xarray_dataclass_to_dict_schema', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050330, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050331, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_optional', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050332, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_constructor', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050333, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_constructor_defaults', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050334, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_typ', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050335, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_missing', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050336, 242998359672049998, 'tests.unit.schema.test_schema', 'test_xarray_dataclass_to_dataset_schema', 0.0, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050337, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050338, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_constructor_dataset_style', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050339, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_constructor_dataset_style_variable', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050340, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_constructor_dataclass_style', 0.007, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050341, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_constructor_auto_coords', 0.004, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050342, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_wrong_dim_order', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050343, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_dtype_mismatch', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050344, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_wrong_dim', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050345, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_extra_datavar', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050346, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_optional_datavar', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050347, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dataset_optional_coordinate', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050348, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_array_attribute', 0.002, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050349, 242998359672049998, 'tests.unit.schema.test_schema', 'test_check_dict_dict_attribute', 0.001, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES (242998359672050350, 242998359672049998, 'tests.unit.schema.test_schema', 'test_schema_export', 0.03, '', '', 'PASSED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);