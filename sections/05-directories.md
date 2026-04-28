## Directory Organization

### Concept and Motivation

Real-world RDF repositories often contain dozens or hundreds of named graphs. Without organizational structure, navigating and managing these graphs becomes unwieldy. DCAT-R addresses this through `dcatr:Directory` - a hierarchical containment mechanism for organizing graphs into named collections.

Directories in DCAT-R are analogous to filesystem directories: they provide named groupings of content items (graphs), can be nested to arbitrary depth, and enable scoped operations and metadata. Unlike filesystem directories, however, DCAT-R directories organize RDF graphs rather than files, and each graph can belong to at most one directory (unique containment).

Use cases for directory organization include:

- **Topical grouping**: Organizing data graphs by subject area (e.g., organic chemistry, inorganic chemistry)
- **Temporal partitioning**: Grouping graphs by time period (e.g., yearly imports)
- **Workflow organization**: Separating graphs by processing stage (e.g., raw, validated, published)
- **Access control scoping**: Defining graph sets for permission boundaries
- **Targeted operations**: Applying transformations or queries to a specific subset of graphs

### Directory as Nested Catalog

A `dcatr:Directory` is simultaneously a `dcat:Catalog` (it catalogs its member elements) and a `dcatr:Element` (it can itself be a member of another directory). This dual nature enables arbitrary nesting.

The containment relationship is established through `dcatr:member`, which links a directory to its direct members. Members can be either `dcatr:Graph` instances or nested `dcatr:Directory` instances - both are `dcatr:Element` subclasses.

Since `dcatr:member` is an `owl:InverseFunctionalProperty`, each element has at most one parent directory. This establishes **unique containment**: every graph and directory has a unique position in the hierarchy.

### Directory Properties

Three properties define the directory structure:

- **`dcatr:member`**: Links a directory to a direct member element (graph or subdirectory). Inverse functional - each element belongs to at most one directory.
- **`dcatr:parentDirectory`**: Inverse of `dcatr:member`. Links an element to its containing directory. Functional - each element has at most one parent.
- **`dcatr:directory`**: A sub-property of `dcatr:member` that specifically links to subdirectories. This is a convenience property; using `dcatr:member` with a `dcatr:Directory` object has the same semantics.

Additionally, the typed containment properties defined in other sections (`dcatr:dataGraph`, `dcatr:repositorySystemGraph`, etc.) are all sub-properties of `dcatr:member`, meaning their use also establishes directory membership.

### Relationship to Dataset and Repository

Three DCAT-R classes are subclasses of `dcatr:Directory`:

- **`dcatr:Dataset`**: The root directory of the data graph hierarchy. It contains `dcatr:DataGraph` instances (via `dcatr:dataGraph`) and nested directories (via `dcatr:directory`).
- **`dcatr:Repository`**: A directory containing the dataset (via `dcatr:repositoryDataset`, which is a sub-property of `dcatr:directory`), system graphs (via `dcatr:repositorySystemGraph`), and the repository manifest graph (via `dcatr:repositoryManifestGraph`).
- **`dcatr:ServiceData`**: A directory containing the service manifest graph, working graphs, and local system graphs.

This means that the entire DCAT-R hierarchy - from repository down to individual graphs - is navigable through directory relationships.

### Example

The following example shows a dataset with data graphs organized into two directories:

<pre class="example" title="Directory structure in a chemistry dataset">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcat:  &lt;http://www.w3.org/ns/dcat#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

# Dataset as root directory
ex:dataset a dcatr:Dataset, dcat:Catalog ;
    dcterms:title "Chemistry Research Data" ;
    dcatr:member ex:molecules ;
    dcatr:directory ex:organic, ex:inorganic .

# Subdirectory: Organic Chemistry
ex:organic a dcatr:Directory, dcat:Catalog ;
    dcterms:title "Organic Chemistry" ;
    dcatr:member ex:organic-structures, ex:organic-experiments .

ex:organic-structures a dcatr:DataGraph ;
    dcterms:title "Organic Molecular Structures" .

ex:organic-experiments a dcatr:DataGraph ;
    dcterms:title "Organic Chemistry Experiments" .

# Subdirectory: Inorganic Chemistry
ex:inorganic a dcatr:Directory, dcat:Catalog ;
    dcterms:title "Inorganic Chemistry" ;
    dcatr:member ex:inorganic-structures .

ex:inorganic-structures a dcatr:DataGraph ;
    dcterms:title "Inorganic Molecular Structures" .

# Graph at the dataset root (not in any subdirectory)
ex:molecules a dcatr:DataGraph ;
    dcterms:title "Core Molecular Database" .
</pre>

In this example, `ex:molecules` is a direct member of the dataset root, while the other data graphs are organized into the `ex:organic` and `ex:inorganic` subdirectories. Each graph belongs to exactly one directory.
