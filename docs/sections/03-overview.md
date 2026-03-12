## Overview

This section provides a high-level overview of the DCAT-R vocabulary. Formal definitions of all classes and properties are given in the subsequent normative sections.

Throughout this specification, a running example is used: a chemistry research repository at a university, serving molecular structure data and experimental results through a SPARQL endpoint.

### DCAT-R as Application Framework

In typical DCAT usage, `dcat:DataService` describes services from an **external perspective**: a SPARQL endpoint has a URL, speaks a protocol, and serves certain datasets. This is the view of a catalog consumer looking at a service from outside.

DCAT-R broadens this perspective. While DCAT-R services can certainly be SPARQL endpoints, the `dcatr:Service` concept encompasses any application that provides operations over an RDF dataset - versioning systems, knowledge base managers, data pipeline processors, validation services, or inference engines. This broader interpretation remains within DCAT 3's intentionally open definition of `dcat:DataService` as "a collection of operations that provides access to one or more datasets or data processing functions."

The key shift is that DCAT-R also takes an **intra-service perspective**: it provides vocabulary for the internal structure that services need to operate. Where plain DCAT describes *what a service looks like from outside*, DCAT-R also describes *how a service organizes its data internally*:

- The **repository** bundles the dataset with operational infrastructure (system graphs) and self-describing metadata (manifest graphs) as a managed unit
- **Service data** separates instance-local configuration from the shared repository
- The **graph type taxonomy** lets the service distinguish user data from configuration, operational infrastructure, and temporary working areas
- **Manifest graphs** carry the configuration and metadata that the service needs to operate

This makes DCAT-R the vocabulary foundation for application frameworks: it defines the structural vocabulary and conventions on which applications build their domain-specific operations. DCAT-R itself does not prescribe any particular operations - it provides the organizational foundation that operations work within.

Notably, DCAT-R models this internal structure using DCAT's own concepts: a repository is a `dcat:Catalog` of its graphs, each graph is a `dcat:Dataset`, and the service remains a `dcat:DataService`. Rather than introducing a separate model for the internal perspective, DCAT-R reuses the familiar catalog–dataset–service pattern at a finer granularity. This means that existing DCAT tooling can process DCAT-R descriptions without any knowledge of the DCAT-R vocabulary - it simply sees catalogs containing datasets served by data services.

### The Four-Level Hierarchy

DCAT-R organizes RDF repository descriptions through a four-level hierarchy, where each level refines a DCAT 3 concept for the specific needs of RDF infrastructure:

```
Service         (what you can do)
 └── Repository (what you have - distributable)
      └── Dataset   (the user data)
           └── Graph     (individual RDF graphs)
```

- **Service** (`dcatr:Service`, extends `dcat:DataService`): The operations layer. A service provides access to a repository and defines what operations are available. Multiple service instances can serve the same repository with different configurations.

- **Repository** (`dcatr:Repository`, extends `dcat:Catalog`): A managed collection that bundles an RDF dataset with operational infrastructure (system graphs) and catalog metadata (repository manifest graph). Analogous to a software repository that combines content with build scripts, configuration, and metadata.

- **Dataset** (`dcatr:Dataset`, extends `dcat:Catalog`): The actual RDF 1.1 dataset - the user data that the repository manages. Modeled as a catalog of its constituent data graphs, optionally organized into directories.

- **Graph** (`dcatr:Graph`, extends `dcat:Dataset`): An individual RDF graph. Graphs are the smallest units of data in DCAT-R and carry their own metadata (title, license, provenance, etc.).

The following example shows this hierarchy for a chemistry research repository:

<pre class="example" title="Four-level hierarchy">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcat:  &lt;http://www.w3.org/ns/dcat#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

# Service
ex:service a dcatr:Service, dcat:DataService ;
    dcterms:title "Chemistry SPARQL Endpoint" ;
    dcatr:serviceRepository ex:repository .

# Repository
ex:repository a dcatr:Repository, dcat:Catalog ;
    dcterms:title "Chemistry Research Repository" ;
    dcatr:repositoryDataset ex:dataset ;
    dcatr:repositoryManifestGraph ex:repository-manifest .

# Dataset
ex:dataset a dcatr:Dataset, dcat:Catalog ;
    dcterms:title "Chemistry Research Data" ;
    dcatr:dataGraph ex:molecules, ex:experiments .

# Graphs
ex:molecules a dcatr:DataGraph ;
    dcterms:title "Molecular Structures" .

ex:experiments a dcatr:DataGraph ;
    dcterms:title "Experimental Results" .

ex:repository-manifest a dcatr:RepositoryManifestGraph .
</pre>

### Graph Type Taxonomy

Not all graphs in a repository serve the same purpose. DCAT-R classifies every graph into exactly one of four disjoint types:

- **DataGraph**: The primary user data - molecular structures, experimental results, knowledge base content. Data graphs form the dataset and are the main content of the repository.

- **ManifestGraph**: Configuration and catalog metadata that DCAT-R itself understands and processes. Two subtypes exist: `ServiceManifestGraph` (instance-local service configuration) and `RepositoryManifestGraph` (distributed catalog description of the repository).

- **SystemGraph**: Operational infrastructure that supports service functionality but is opaque to DCAT-R. Examples include version history graphs, provenance records, inference results, or shared indexes. System graphs can be distributed (part of the repository) or local (part of service data).

- **WorkingGraph**: Temporary, service-local graphs for drafts, staging areas, caches, or experimental work. Working graphs are never distributed.

These four types are defined as pairwise disjoint OWL classes whose union equals `dcatr:Graph`. This ensures that every graph has an unambiguous classification, enabling applications to reliably distinguish user data from infrastructure.

Orthogonally to this content-based classification, graphs can also be classified by their naming role in the RDF dataset: `DefaultGraph` (the unnamed graph) or `NamedGraph` (identified by a graph name). This naming classification is service-specific - the same graph may serve as the default graph in one service instance but as a named graph in another. The `dcatr:localGraphName` property enables service-specific aliasing of graph names, allowing a graph's canonical URI to differ from the name under which it appears in a particular service's RDF dataset.

### Distribution Boundary

A key architectural principle in DCAT-R is the clear separation between **distributed** data (shared across service instances) and **local** data (specific to one service instance).

The service aggregates data from two catalogs:

```
Service
 ├── Repository (distributed)
 │    ├── Dataset
 │    │    └── DataGraphs
 │    ├── RepositoryManifestGraph
 │    └── SystemGraphs (distributed)
 │
 └── ServiceData (local)
      ├── ServiceManifestGraph
      ├── WorkingGraphs
      └── SystemGraphs (local)
```

- **Repository** contains everything that is part of the distribution: the dataset with its data graphs, the repository manifest graph with DCAT catalog metadata, and distributed system graphs (e.g., version history, provenance). When the repository is replicated or shared, all of this travels together.

- **ServiceData** (`dcatr:ServiceData`) contains everything that is local to a particular service instance: the service manifest graph with instance-specific configuration (graph name mappings, default graph designation), working graphs for temporary data, and local system graphs (caches, logs). Service data is never distributed.

This separation enables multi-instance deployments where different service instances serve the same repository with different configurations, storage backends, or graph naming schemes.

### Use Cases

#### Application and Service Framework

The primary use case for DCAT-R is as the vocabulary foundation for application frameworks that build services over RDF datasets (see [[[#dcat-r-as-application-framework]]]). Applications extend DCAT-R by:

1. **Defining a service type** as a subclass of `dcatr:Service` with specific operations (e.g., commit, query, validate, infer).
2. **Adding system graphs** as subclasses of `dcatr:SystemGraph` to store operational data (e.g., version history, inference results, validation reports).
3. **Extending the manifest** with application-specific configuration properties.

Examples of services that can be built on DCAT-R:

- **Versioned repositories**: With history graphs tracking commits and provenance
- **Knowledge base services**: With inference graphs, validation reports, and index graphs
- **Data pipeline services**: With transformation graphs and processing logs
- **Collaborative platforms**: With working graphs for drafts and review workflows

#### RDF Dataset Description

As a secondary use case, DCAT-R provides structured vocabulary for **describing RDF datasets at the graph level**. Even without the service and framework aspects, the graph type taxonomy, directory organization, and DCAT-compatible metadata model are useful for:

- **Cataloging multi-graph datasets**: Describing individual named graphs with their own metadata (title, license, provenance, creation date)
- **Classifying graph purposes**: Distinguishing data graphs from infrastructure graphs in datasets that contain both
- **Organizing large datasets**: Using directories to provide hierarchical structure for datasets with many graphs
- **DCAT-compatible discovery**: Since all DCAT-R classes extend DCAT 3, DCAT-R descriptions are discoverable by standard DCAT-aware tools and catalogs
