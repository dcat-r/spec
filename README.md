<p align="center">
  <img src="docs/dcatr-logo.png" alt="DCAT-R Logo" width="125" align="right">
</p>

# DCAT-R Specification

DCAT-R (Data Catalog Vocabulary for RDF Repositories) extends [DCAT 3](https://www.w3.org/TR/vocab-dcat-3/) with classes and properties for describing RDF repositories, their datasets, and named graphs through a four-level hierarchy: Service, Repository, Dataset, Graph.

This repository contains the [ReSpec](https://respec.org/) specification document and the DCAT-R vocabulary definition.

## Prerequisites

- [Node.js](https://nodejs.org/) (for local preview)
- [pyLODE](https://github.com/RDFLib/pyLODE) (for generating term documentation)
- [raptor](https://librdf.org/raptor/) (for RDF validation and format conversion)
- [rdflib](https://rdflib.readthedocs.io/) (for JSON-LD conversion)

## Quick Start

```bash
npm install
npm run serve
```

This opens the specification at `http://localhost:3000`.

## Commands

| Command | Description |
|---------|-------------|
| `npm run serve` | Live preview on localhost:3000 |
| `npm run dev` | Live preview with auto-reload on file changes |
| `make` | Build all (term docs + format conversions) |
| `make validate` | Validate ontology RDF syntax |
| `make formats` | Convert Turtle to N-Triples, RDF/XML, JSON-LD |
| `make clean` | Remove generated files |

## Project Structure

```
spec/
├── docs/
│   ├── index.html              # ReSpec specification document
│   └── sections/               # Markdown sections (included by ReSpec)
├── vocab/
│   └── dcatr.ttl               # DCAT-R vocabulary (Turtle)
├── examples/
│   └── example-repository.ttl  # Example DCAT-R descriptions
└── package.json
```

## Further Reading

- [ReSpec documentation](https://respec.org/docs/)
- [DCAT 3 specification](https://www.w3.org/TR/vocab-dcat-3/)

## License

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
