## Manifests and Configuration

### What is a Manifest?

In the application framework context, a **manifest** is the RDF-based configuration that a service loads to initialize its internal structure. It describes which repository the service operates on, what graphs exist, how they are organized, and how the service should be configured.

Manifests are the mechanism through which DCAT-R descriptions become active configuration: a service implementation reads the manifest and builds the runtime representation of its repository, dataset, graphs, and local settings from it. This makes manifests primarily relevant in the application framework context. For the secondary use case of pure RDF dataset annotation, manifest infrastructure is not required - DCAT-R classes and properties can be used directly as descriptive metadata.

### The Two Manifest Graphs

A manifest consists of two graphs, reflecting the [distribution boundary](#distribution-boundary):

The **repository manifest graph** (`dcatr:RepositoryManifestGraph`) contains the DCAT catalog description of the repository. This is distributed content - it travels with the repository when replicated or shared between service instances:

- Repository metadata (title, description, publisher, license)
- Dataset catalog information (graph descriptions, directory structure)
- Graph type declarations (`dcatr:DataGraph`, `dcatr:SystemGraph`, etc.)

The **service manifest graph** (`dcatr:ServiceManifestGraph`) contains instance-specific configuration that is local to one service and never distributed:

- Which graph serves as the default graph in this instance
- Local graph name mappings (`dcatr:localGraphName`)
- Instance-specific settings (storage endpoints, cache parameters)

This separation ensures that when a repository is replicated or migrated, the repository metadata travels with it while the service configuration is established fresh for each instance. The same repository can be served by multiple service instances, each with its own service manifest graph.

<div class="note">

The `dcatr:RepositoryManifestGraph` exhibits a controlled self-reference: it describes the repository of which it is a part, analogous to a book's table of contents being part of the book it describes. The repository manifest graph MUST have its own URI distinct from the repository URI to maintain clear identity boundaries.

</div>

### Manifest Serialization

Implementations typically support two approaches for loading manifest configuration:

**Separate files**: Each manifest graph is stored in its own Turtle file (e.g., `service.ttl` and `repository.ttl`). The graph boundary is implicit - each file corresponds to one manifest graph.

**Single TriG file**: Both manifest graphs are stored in a single TriG file as named graphs within an RDF dataset. This approach requires graph names to identify the manifest graphs. DCAT-R defines well-known blank node labels as conventions for this purpose:

- **`_:service-manifest`** SHOULD be used as the graph name for the service manifest graph.
- **`_:repository-manifest`** SHOULD be used as the graph name for the repository manifest graph.

These conventions enable implementations to locate manifest graphs by convention without prior configuration.

<pre class="example" title="Manifest as a TriG file with well-known blank node graph names">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

_:service-manifest {
    ex:service a dcatr:Service ;
        dcatr:serviceRepository ex:repository ;
        dcatr:usePrimaryAsDefault true .
}

_:repository-manifest {
    ex:repository a dcatr:Repository ;
        dcterms:title "Chemistry Research Repository" ;
        dcatr:repositoryDataset ex:dataset ;
        dcatr:repositoryPrimaryGraph ex:molecules ;
        dcatr:repositoryManifestGraph ex:repository-manifest .

    ex:dataset a dcatr:Dataset ;
        dcatr:dataGraph ex:molecules .

    ex:molecules a dcatr:DataGraph ;
        dcterms:title "Core Molecular Database" .

    ex:repository-manifest a dcatr:RepositoryManifestGraph .
}
</pre>

### Manifest Graph Expansion

When manifest configuration is spread across multiple files (e.g., a global configuration file and a project-specific file), shared resources such as agent descriptions or organization metadata may be relevant to both manifest graphs.

**Manifest Graph Expansion** (MGE) is an optional loading mechanism that addresses this by automatically including referenced resources from a shared pool (the default graph of the TriG file) into the appropriate manifest graphs. The mechanism works as follows:

1. Resources explicitly defined in a manifest graph serve as **seed resources**.
2. For each seed resource, triples about resources referenced as objects are pulled from the default graph.
3. This expansion can be applied recursively to a configurable depth.

For example, if the service manifest references an agent (`prov:wasAttributedTo ex:alice`), and `ex:alice` is described in the default graph, MGE automatically includes the agent's description in the service manifest graph.

MGE is disabled by default to avoid unexpected graph pollution. When enabled, it provides a DRY (Don't Repeat Yourself) pattern for shared resources across manifest graphs.
