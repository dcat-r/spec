<br />
<div align="center">
  <img src="docs/dcatr-logo.png" alt="DCAT-R Logo" width="200">

<h2 align="center">DCAT-R</h2>

  <p align="center">
    A vocabulary for data services over RDF repositories
    <br />
    <br />
    <a href="https://w3id.org/dcatr"><strong>Read the Spec »</strong></a>
    <br />
    <a href="https://dcat-r.github.io/spec/terms/index.html"><strong>Explore the vocabulary »</strong></a>
    <br />
    <br />
    <a href="https://github.com/dcat-r/spec/blob/main/CHANGELOG.md">Changelog</a>
    ·
    <a href="https://github.com/dcat-r/spec/issues">Report Error</a>
    ·
    <a href="https://github.com/dcat-r/spec/issues">Request Feature</a>
    ·
    <a href="https://github.com/orgs/dcat-r/discussions">Discussions</a>
  </p>
</div>

## About the Project

DCAT-R (Data Catalog Vocabulary for RDF Repositories) extends [DCAT 3](https://www.w3.org/TR/vocab-dcat-3/) with classes and properties for describing RDF repositories, their datasets, and named graphs through a four-level hierarchy: Service, Repository, Dataset, Graph.

This repository contains the [ReSpec](https://respec.org/) specification document and the vocabulary definition.

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

## Acknowledgements

<table style="border: 0;">
<tr>
<td><a href="https://nlnet.nl/"><img src="https://nlnet.nl/logo/banner.svg" alt="NLnet Foundation Logo" height="100"></a></td>
<td><a href="https://nlnet.nl/core" ><img src="https://nlnet.nl/logo/NGI/NGIZero-green.hex.svg" alt="NGI Zero Core Logo" height="150"></a></td>
</tr>
</table>

This project is funded through [NGI Zero Core](https://nlnet.nl/core), a fund established by [NLnet](https://nlnet.nl/) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu/) program.

## License

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
