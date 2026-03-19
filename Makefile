ONTOLOGY     = vocab/dcatr.ttl
ONTOLOGY_EX  = ../dcatr-ex/priv/vocabs/dcatr.ttl

# Output files
TERMS_HTML = docs/terms/index.html
RDF_XML    = vocab/dcatr.rdf
JSONLD     = vocab/dcatr.jsonld
NT         = vocab/dcatr.nt

FORMATS =  $(NT) $(RDF_XML) $(JSONLD)

# Diagrams
PUML_SRC = $(wildcard docs/diagrams/*.puml)
PUML_SVG = $(PUML_SRC:.puml=.svg)

.PHONY: all validate clean sync diagrams

all: $(TERMS_HTML) $(FORMATS) $(PUML_SVG)

# Diagrams
diagrams: $(PUML_SVG)

docs/diagrams/%.svg: docs/diagrams/%.puml
	plantuml -tsvg $<

# Validation
validate: $(ONTOLOGY)
	rapper -i turtle -c $<

# Term documentation
$(TERMS_HTML): $(ONTOLOGY)
	@mkdir -p $(dir $@)
	pylode $< -o $@ -p ontpub --css true

# Format conversions
formats: $(FORMATS)

$(NT): $(ONTOLOGY)
	rapper -i turtle -o ntriples $< > $@

$(RDF_XML): $(ONTOLOGY)
	rapper -i turtle -o rdfxml $< > $@

$(JSONLD): $(ONTOLOGY)
	python3 -c "from rdflib import Graph; g = Graph(); g.parse('$<'); print(g.serialize(format='json-ld'))" > $@

# Sync vocabulary: copy newer file over older one
sync:
	@if [ $(ONTOLOGY) -nt $(ONTOLOGY_EX) ]; then \
		cp -v $(ONTOLOGY) $(ONTOLOGY_EX); \
	elif [ $(ONTOLOGY_EX) -nt $(ONTOLOGY) ]; then \
		cp -v $(ONTOLOGY_EX) $(ONTOLOGY); \
	else \
		echo "Already in sync."; \
	fi

clean:
	rm -f $(FORMATS) $(TERMS_HTML) $(PUML_SVG)
