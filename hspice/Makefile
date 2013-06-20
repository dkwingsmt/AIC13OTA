.PHONY: all clean make_dir

SILENT = 2> /dev/null || true

COPY_OBJECTS = $(wildcard raw/*.txt) $(wildcard raw/*.m) \
			   raw/project.sp raw/params.sp raw/utils.sp
COPY_TARGETS = $(patsubst raw/%, workspace/%, $(COPY_OBJECTS))
MODES = ac noise tr dc 
SP_TARGETS = $(patsubst %, workspace/ota_test_%.sp, $(MODES))
LIS_TARGETS = $(patsubst %.sp, %.lis, $(SP_TARGETS))

all: make_dir $(COPY_TARGETS) $(SP_TARGETS) $(LIS_TARGETS)

clean:
	-@rm -rf workspace/* $(SILENT)

make_dir:
	-@mkdir workspace $(SILENT)

$(COPY_TARGETS) : workspace/% : raw/%  
	-@rm $@	$(SILENT)
	-cp $< $@ 

$(SP_TARGETS) : % : raw/ota_test.sp
	python raw/format.py $< $@ - $(patsubst workspace/ota_test_%.sp, %, $@)

$(LIS_TARGETS) : %.lis : %.sp
	@echo
	@echo ====== $< ======
	-@(cd workspace && \
		hspice $(patsubst workspace/%, %, $<) \
			| tee $(patsubst workspace/%, %, $@) \
			| egrep -A1 '\*\*(warning)|(error)\*\*' \
		)
