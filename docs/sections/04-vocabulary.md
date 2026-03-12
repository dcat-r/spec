## Vocabulary Specification

This section describes the classes and properties of the DCAT-R vocabulary, focusing on their architectural roles and usage patterns. For complete formal definitions (IRIs, domains, ranges, superclass chains, OWL axioms), see the [term reference](terms/index.html).

### Class Overview

| Class | Superclass(es) | Role |
|-------|---------------|------|
| `dcatr:Service` | `dcat:DataService` | Operations layer providing access to a repository |
| `dcatr:ServiceData` | `dcat:Catalog`, `dcatr:Directory` | Instance-local catalog of service-specific graphs |
| `dcatr:Repository` | `dcat:Catalog`, `dcatr:Directory` | Distributable collection of dataset + infrastructure |
| `dcatr:Dataset` | `dcat:Catalog`, `dcatr:Directory` | Root catalog of user data graphs |
| `dcatr:Element` | `dcat:Resource` | Abstract base for directory members |
| `dcatr:Directory` | `dcat:Catalog`, `dcatr:Element` | Hierarchical organization of graphs |
| `dcatr:Graph` | `dcat:Dataset`, `dcatr:Element` | Abstract base for all graphs (union of four types) |
| `dcatr:DataGraph` | `dcatr:Graph` | User data |
| `dcatr:ManifestGraph` | `dcatr:Graph` | DCAT-R configuration and catalog metadata |
| `dcatr:ServiceManifestGraph` | `dcatr:ManifestGraph` | Service-local configuration |
| `dcatr:RepositoryManifestGraph` | `dcatr:ManifestGraph` | Distributed catalog description |
| `dcatr:SystemGraph` | `dcatr:Graph` | Application-specific operational data |
| `dcatr:WorkingGraph` | `dcatr:Graph` | Temporary, service-local graphs |
| `dcatr:DefaultGraph` | `dcatr:Graph` | Default graph designation (service-specific) |
| `dcatr:NamedGraph` | `dcatr:Graph` | Named graph with optional local name alias |
| `dcatr:Manifest` | `foaf:Document` | Manifest document linking to its service |

<div class="note">

When DCAT-R descriptions are intended for use in contexts where consumers may not perform OWL reasoning - such as general-purpose data catalogs or DCAT-only tooling - it is RECOMMENDED to explicitly include the DCAT 3 superclass types. For example, a repository should be typed as both `dcatr:Repository` and `dcat:Catalog`:

<pre class="example" title="Explicit DCAT superclass typing">
ex:repository a dcatr:Repository, dcat:Catalog ;
    dcterms:title "My Repository" .
</pre>

This ensures that DCAT-aware tools can discover and process DCAT-R descriptions even without reasoning support.

</div>

### Property Overview

| Property | Domain | Range | Notes |
|----------|--------|-------|-------|
| `dcatr:serviceRepository` | `Service` | `Repository` | Functional; sub-property of `dcat:servesDataset` |
| `dcatr:serviceLocalData` | `Service` | `ServiceData` | Functional |
| `dcatr:usePrimaryAsDefault` | `Service` | `xsd:boolean` | Three-value semantics (see below) |
| `dcatr:repositoryDataset` | `Repository` | `Dataset` | Functional; sub-property of `dcatr:directory` |
| `dcatr:repositoryPrimaryGraph` | `Repository` | `DataGraph` | Functional; pure designator (no containment) |
| `dcatr:repositoryDataGraph` | `Repository` | `DataGraph` | Functional; sub-property of `repositoryPrimaryGraph` + `member` |
| `dcatr:repositorySystemGraph` | `Repository` | `SystemGraph` | Sub-property of `dcatr:member` |
| `dcatr:repositoryManifestGraph` | `Repository` | `RepositoryManifestGraph` | Functional; sub-property of `dcatr:member` |
| `dcatr:serviceManifestGraph` | `ServiceData` | `ServiceManifestGraph` | Functional; sub-property of `dcatr:member` |
| `dcatr:serviceWorkingGraph` | `ServiceData` | `WorkingGraph` | Sub-property of `dcatr:member` |
| `dcatr:serviceSystemGraph` | `ServiceData` | `SystemGraph` | Sub-property of `dcatr:member` |
| `dcatr:dataGraph` | `Dataset` | `DataGraph` | Sub-property of `dcatr:member` |
| `dcatr:member` | `Directory` | `Element` | Inverse functional; sub-property of `dcat:dataset` |
| `dcatr:parentDirectory` | `Element` | `Directory` | Functional; inverse of `dcatr:member` |
| `dcatr:directory` | `Directory` | `Directory` | Sub-property of `dcatr:member` |
| `dcatr:localGraphName` | `NamedGraph` | `rdfs:Resource` | Service-specific graph name alias |
| `dcatr:manifestService` | `Manifest` | `Service` | Functional; sub-property of `foaf:primaryTopic` |


### Service and ServiceData

`dcatr:Service` is the primary extension point for applications built on DCAT-R. Applications define specialized service types (as subclasses) with their own operations and configuration.

Multiple service instances can serve the same repository. Each instance has its own local configuration in a `dcatr:ServiceData` catalog, which is typically instantiated as a blank node.

### Repository: Two Usage Patterns

DCAT-R supports two patterns for linking a repository to its data:

- **Multi-graph pattern**: Use `dcatr:repositoryDataset` to link to a `dcatr:Dataset` containing multiple data graphs. If one graph serves as the primary entry point, designate it with `dcatr:repositoryPrimaryGraph`.
- **Single-graph shortcut**: Use `dcatr:repositoryDataGraph` to link directly to a single `dcatr:DataGraph`. This convenience property combines primary designation (via `dcatr:repositoryPrimaryGraph`) and containment (via `dcatr:member`) in one statement.

A repository MUST use exactly one of these two patterns. Implementations SHOULD reject a repository that specifies neither or both.

<pre class="example" title="Multi-graph pattern vs. single-graph shortcut">
# Multi-graph pattern
ex:repository dcatr:repositoryDataset ex:dataset ;
    dcatr:repositoryPrimaryGraph ex:molecules .

# Single-graph shortcut (equivalent for single-graph case)
ex:repository dcatr:repositoryDataGraph ex:mainGraph .
</pre>

### Dataset Containment

Only `dcatr:DataGraph` instances belong to the dataset. System graphs, manifest graphs, and working graphs are linked to the repository or service data, not to the dataset. Implementations SHOULD reject attempts to add non-DataGraph instances to a dataset.

### Graph Type Taxonomy

Every graph MUST belong to exactly one of the four pairwise disjoint graph types described in [[[#graph-type-taxonomy-0]]]. See also [[[#manifests-and-configuration]]] for details on the two `ManifestGraph` subtypes.

### Graph Naming

The `DefaultGraph`/`NamedGraph` classification is **orthogonal** to the four content-based types - a graph can be both a `dcatr:DataGraph` and a `dcatr:NamedGraph`. This classification is **service-specific**: the same graph may be the default graph in one service instance but a named graph in another.

`dcatr:localGraphName` enables service-specific aliasing: a graph's canonical URI can differ from the name under which it appears in a particular service's RDF dataset. This property SHOULD be unique within a service instance (enforced by implementations, not by OWL semantics).

<div class="note">

`dcatr:localGraphName` is intentionally not declared as `owl:InverseFunctionalProperty` to avoid global inference conflicts between independent service instances that may use the same local name for different graphs.

</div>

### Primary Graph and Default Graph

In many repositories, one data graph serves as the main entry point - the graph that operations target by default when no specific graph is specified. DCAT-R calls this the **primary graph**, designated via `dcatr:repositoryPrimaryGraph`. This is a repository-level concept: the primary graph is part of the repository description and shared across all service instances.

The **default graph** is a different, service-level concept: it refers to the unnamed graph in an RDF 1.1 dataset, the graph that SPARQL queries target when no `GRAPH` clause is used. Which graph serves as the default graph can vary between service instances.

The `dcatr:usePrimaryAsDefault` property on the service controls the relationship between these two concepts:

- **Absent** (no value): Auto mode - if no explicit default graph is configured in the service manifest, the primary graph becomes the default. If an explicit default is configured, it takes precedence.
- **`true`**: Enforce mode - the primary graph MUST be the default graph.
- **`false`**: Disable mode - no automatic designation. The service must explicitly configure a default graph, or none will be set.

### OWL Constraints

The DCAT-R vocabulary uses OWL constructs to enforce structural integrity:

**Disjointness**: The four graph types are pairwise disjoint. `DefaultGraph` and `NamedGraph` are also disjoint.

**Union class**: `dcatr:Graph` is equivalent to the union of the four graph types, making it a closed, abstract class.

**Functional properties**: `dcatr:serviceRepository`, `dcatr:serviceLocalData`, `dcatr:repositoryDataset`, `dcatr:repositoryPrimaryGraph`, `dcatr:repositoryDataGraph`, `dcatr:repositoryManifestGraph`, `dcatr:serviceManifestGraph`, `dcatr:manifestService`, `dcatr:parentDirectory`.

**Inverse functional property**: `dcatr:member` ensures each element belongs to at most one directory (unique containment). `dcatr:parentDirectory` is its inverse.
