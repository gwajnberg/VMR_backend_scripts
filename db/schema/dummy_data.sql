INSERT INTO samples(sample_collector_sample_id) VALUES ('TEST001');
INSERT INTO isolates(sample_id, isolate_id) VALUES (1, 'ISO001');
INSERT INTO extractions(nucleic_acid_extraction_method) VALUES ('wgs');
INSERT INTO sequencing(extraction_id) VALUES (1);
INSERT INTO wgs_extractions(isolate_id,extraction_id) VALUES (1,1);

