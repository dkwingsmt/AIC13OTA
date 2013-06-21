.PHONY: all clean make_dir run

SILENT = 2> /dev/null || true

INCLUDED_FILES = raw/project.sp raw/params.sp raw/utils.sp raw/input_diff.sp
COPY_OBJECTS = $(wildcard raw/*.txt) $(INCLUDED_FILES)
COPY_TARGETS = $(patsubst raw/%, workspace/%, $(COPY_OBJECTS))
MODES = ac noise tr dc 
SP_TARGETS = $(patsubst %, workspace/ota_test_%.sp, $(MODES))
LIS_TARGETS = $(patsubst %.sp, %.lis, $(SP_TARGETS))

all: make_dir $(COPY_TARGETS) $(SP_TARGETS) $(LIS_TARGETS)

clean:
	-@rm -rf workspace/* $(SILENT)

make_dir:
	-@mkdir workspace $(SILENT)

run: $(LIS_TARGETS)

$(COPY_TARGETS) : workspace/% : raw/%  
	-@rm $@	$(SILENT)
	-cp $< $@ 

$(SP_TARGETS) : % : raw/ota_test.sp
	python raw/format.py $< $@ - $(patsubst workspace/ota_test_%.sp, %, $@)

$(LIS_TARGETS) : %.lis : %.sp $(patsubst raw/%, workspace/%, $(INCLUDED_FILES))
	@echo
	@echo ====== $< ======
	-@(cd workspace && \
		hspice $(patsubst workspace/%.lis, %.sp, $@) \
			| tee $(patsubst workspace/%.lis, %.lis, $@) \
			| egrep -A1 '\*\*(warning)|(error)\*\*' \
		)
