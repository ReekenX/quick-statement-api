.PHONY: mockups

mockups:
	rake data:export
	rsync -Pa tmp/*.json 2gb:projects/api.riseshot.com/tmp/
	ssh 2gb docker exec -i riseshot.com-api rake data:import
