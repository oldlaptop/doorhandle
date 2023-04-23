.POSIX:

.SUFFIXES: .scad .stl .png

OPENSCAD = openscad
OPENSCAD_FLAGS =

.scad.stl:
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<
.scad.png:
	$(OPENSCAD) --autocenter --viewall $(OPENSCAD_FLAGS) -o $@ $<

MODELS = doorhandle.stl
models: $(MODELS)

PREVIEWS = doorhandle.png
previews: $(PREVIEWS)

clean:
	rm -f $(MODELS) $(PREVIEWS)

help:
	@echo "available targets: models, previews, clean"
	@echo "influential macros:"
	@echo "    OPENSCAD:       openscad binary, currently: $(OPENSCAD)"
	@echo "    OPENSCAD_FLAGS: flags to pass to openscad, currently: $(OPENSCAD_FLAGS)"
