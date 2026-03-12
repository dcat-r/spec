## Introduction

### Motivation and Scope

[[[DCAT3]]] is a general-purpose vocabulary for describing datasets, data services, and their distributions in catalogs. By design, DCAT 3 focuses on the external perspective: cataloging datasets for discovery, describing service endpoints for consumers, and providing rich metadata for interoperability across domains and data formats. Its deliberate openness and flexibility make it the standard for data catalogs of all kinds.

DCAT-R extends DCAT 3 in two dimensions to address the needs of applications that operate over RDF datasets:

RDF-specific refinements: DCAT 3 treats datasets as opaque units. For RDF datasets, which consist of a default graph and zero or more named graphs, more specific vocabulary is useful:

- **Graph-level metadata**: Describing individual graphs within a dataset and classifying them by purpose (user data, configuration, operational infrastructure, temporary work)
- **Graph naming**: Mapping between a graph's canonical identity and the local name under which it appears in a particular service's RDF dataset

Intra-service perspective: Where DCAT 3 describes services from the outside - endpoint URLs, supported protocols, served datasets - DCAT-R adds an internal perspective on service structure. Applications that manage RDF data need vocabulary not just for describing their services to external consumers, but for organizing the data and metadata that their operations work with:

- **Repository structure**: Bundling an RDF dataset with its operational infrastructure (version history, indexes, provenance records) as a managed, distributable unit
- **Service configuration**: Separating distributed repository data from instance-local configuration, enabling multiple service instances to serve the same repository differently
- **Graph type taxonomy**: Classifying graphs by their role in the service - user data, configuration, system mechanisms, or temporary working areas

DCAT-R makes these refinements by extending DCAT 3 with an OWL vocabulary that models RDF repositories through a four-level hierarchy (Service, Repository, Dataset, Graph), classifies graphs into four disjoint types, provides hierarchical directory organization, and defines a manifest-based configuration system. This vocabulary provides the foundation for application frameworks that build services over RDF repositories - it does not define protocols, APIs, query languages, or specific operations, but provides the structural vocabulary on which applications define their own. A reference implementation is available in [DCAT-R.ex](https://github.com/dcat-r/dcat-r-ex).

### Terminology

The following terms are used throughout this specification:

- **Service**: A `dcat:DataService` instance that provides operations over a repository. Each service instance has its own local configuration and may serve the same repository differently.
- **Repository**: A managed collection of an RDF dataset together with its operational infrastructure (system graphs) and catalog metadata (manifest graph). Analogous to a software repository (Git, npm) that bundles content with metadata and mechanisms.
- **Dataset**: The RDF 1.1 dataset containing the actual user data as a collection of named graphs and optionally a default graph.
- **Graph**: An individual RDF graph within the repository. Every graph belongs to exactly one of four disjoint types: DataGraph, ManifestGraph, SystemGraph, or WorkingGraph.
- **Directory**: A named collection of graphs and nested directories within a dataset, enabling hierarchical organization.
- **Element**: Abstract base for items that can be organized within directories - either graphs or directories themselves.
- **Manifest**: A configuration structure consisting of manifest graphs that describe the service and repository. The service manifest graph contains instance-local configuration; the repository manifest graph contains distributed catalog metadata.
- **Distribution boundary**: The separation between data that is distributed with the repository (dataset, system graphs, repository manifest) and data that remains local to a service instance (service manifest, working graphs, local system graphs).

### Namespaces and Prefixes

The following namespace prefixes are used throughout this specification:

| Prefix | Namespace | Description |
|--------|-----------|-------------|
| `dcatr:` | `https://w3id.org/dcatr#` | DCAT-R (this vocabulary) |
| `dcat:` | `http://www.w3.org/ns/dcat#` | Data Catalog Vocabulary |
| `dcterms:` | `http://purl.org/dc/terms/` | Dublin Core Terms |
| `rdf:` | `http://www.w3.org/1999/02/22-rdf-syntax-ns#` | RDF |
| `rdfs:` | `http://www.w3.org/2000/01/rdf-schema#` | RDF Schema |
| `owl:` | `http://www.w3.org/2002/07/owl#` | OWL |
| `xsd:` | `http://www.w3.org/2001/XMLSchema#` | XML Schema Datatypes |
| `skos:` | `http://www.w3.org/2004/02/skos/core#` | SKOS |
| `foaf:` | `http://xmlns.com/foaf/0.1/` | FOAF |
| `prov:` | `http://www.w3.org/ns/prov#` | PROV Ontology |
