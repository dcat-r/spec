## Examples

The following examples illustrate DCAT-R usage at different levels of complexity, all based on a chemistry research repository at a university. Each example builds on the previous one, demonstrating increasingly complete descriptions.

For clarity, comments indicate which manifest graph the statements belong to. See [[[#manifest-serialization]]] for how this translates to concrete file formats (separate Turtle files or a single TriG file with well-known blank node graph names).

### Minimal Repository

The simplest DCAT-R description: a repository with a single data graph, using the `dcatr:repositoryDataGraph` shortcut that combines primary designation and containment.

<pre class="example" title="Minimal single-graph repository">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcat:  &lt;http://www.w3.org/ns/dcat#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

# --- Service manifest graph ---

ex:service a dcatr:Service, dcat:DataService ;
    dcterms:title "Chemistry SPARQL Endpoint" ;
    dcatr:serviceRepository ex:repository .

# --- Repository manifest graph ---

ex:repository a dcatr:Repository, dcat:Catalog ;
    dcterms:title "Chemistry Research Repository" ;
    dcatr:repositoryDataGraph ex:molecules ;
    dcatr:repositoryManifestGraph ex:repository-manifest .

ex:molecules a dcatr:DataGraph, dcat:Dataset ;
    dcterms:title "Core Molecular Database" .

ex:repository-manifest a dcatr:RepositoryManifestGraph .
</pre>

This example uses explicit DCAT superclass types (`dcat:DataService`, `dcat:Catalog`, `dcat:Dataset`) for interoperability with non-reasoning systems, as recommended in [[[#class-overview]]]. The following examples omit them for brevity.


### Multi-Graph Dataset with Directories

A repository with multiple data graphs organized into directories, a system graph for provenance, and a designated primary graph.

<pre class="example" title="Multi-graph repository with directory organization">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt; .
@prefix xsd:  &lt;http://www.w3.org/2001/XMLSchema#&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

# --- Repository manifest graph ---

# Repository with dataset and system graph
ex:repository a dcatr:Repository ;
    dcterms:title "Chemistry Research Repository" ;
    dcterms:publisher ex:university ;
    dcterms:license &lt;https://creativecommons.org/licenses/by/4.0/&gt; ;
    dcatr:repositoryDataset ex:dataset ;
    dcatr:repositoryPrimaryGraph ex:molecules ;
    dcatr:repositoryManifestGraph ex:repository-manifest ;
    dcatr:repositorySystemGraph ex:provenance .

# Dataset with directory organization
ex:dataset a dcatr:Dataset ;
    dcterms:title "Chemistry Research Data" ;
    dcterms:issued "2024-01-15"^^xsd:date ;
    dcatr:member ex:molecules ;
    dcatr:directory ex:organic, ex:inorganic .

# Primary graph at dataset root
ex:molecules a dcatr:DataGraph ;
    dcterms:title "Core Molecular Database" ;
    dcterms:description "Cross-disciplinary molecular structure reference data" .

# Organic chemistry directory
ex:organic a dcatr:Directory ;
    dcterms:title "Organic Chemistry" ;
    dcatr:member ex:organic-structures, ex:organic-experiments .

ex:organic-structures a dcatr:DataGraph ;
    dcterms:title "Organic Molecular Structures" ;
    dcterms:created "2024-01-15"^^xsd:date .

ex:organic-experiments a dcatr:DataGraph ;
    dcterms:title "Organic Chemistry Experiments" ;
    dcterms:created "2024-03-20"^^xsd:date .

# Inorganic chemistry directory
ex:inorganic a dcatr:Directory ;
    dcterms:title "Inorganic Chemistry" ;
    dcatr:member ex:inorganic-structures .

ex:inorganic-structures a dcatr:DataGraph ;
    dcterms:title "Inorganic Molecular Structures" ;
    dcterms:created "2024-06-01"^^xsd:date .

# Distributed system graph
ex:provenance a dcatr:SystemGraph ;
    dcterms:title "Provenance Graph" ;
    dcterms:description "Tracks data origin and transformation history" .

# Repository manifest
ex:repository-manifest a dcatr:RepositoryManifestGraph .

# Publisher
ex:university a foaf:Organization ;
    foaf:name "Example University" .
</pre>


### Complete Service with Local Data

A complete example showing the full DCAT-R hierarchy including service-local data with manifest, working graph, graph naming, and default graph designation.

<pre class="example" title="Complete service with local data and graph naming">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix dcat: &lt;http://www.w3.org/ns/dcat#&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

# --- Service manifest graph ---

ex:service a dcatr:Service ;
    dcterms:title "Chemistry SPARQL Endpoint" ;
    dcat:endpointURL &lt;https://data.example.org/sparql&gt; ;
    dcterms:conformsTo &lt;https://www.w3.org/TR/sparql11-protocol/&gt; ;
    dcatr:serviceRepository ex:repository ;
    dcatr:serviceLocalData _:local ;
    dcatr:usePrimaryAsDefault true .

_:local a dcatr:ServiceData ;
    dcatr:serviceManifestGraph _:service-manifest ;
    dcatr:serviceWorkingGraph ex:staging ;
    dcatr:serviceSystemGraph ex:queryCache .

_:service-manifest a dcatr:ServiceManifestGraph .

# Graph naming: the primary graph uses a different local name in this service
ex:molecules a dcatr:NamedGraph ;
    dcatr:localGraphName &lt;https://data.example.org/graphs/molecules&gt; .

# Working graph for staging imports
ex:staging a dcatr:WorkingGraph ;
    dcterms:title "Staging Area" ;
    dcterms:description "Temporary graph for reviewing data before import" .

# Local system graph for caching
ex:queryCache a dcatr:SystemGraph ;
    dcterms:title "Query Cache" ;
    dcterms:description "Local cache of frequently used query results" .

# --- Repository manifest graph ---

ex:repository a dcatr:Repository ;
    dcterms:title "Chemistry Research Repository" ;
    dcatr:repositoryDataset ex:dataset ;
    dcatr:repositoryPrimaryGraph ex:molecules ;
    dcatr:repositoryManifestGraph ex:repository-manifest .

ex:dataset a dcatr:Dataset ;
    dcatr:dataGraph ex:molecules, ex:experiments .

ex:molecules a dcatr:DataGraph ;
    dcterms:title "Core Molecular Database" .

ex:experiments a dcatr:DataGraph ;
    dcterms:title "Experimental Results" .

ex:repository-manifest a dcatr:RepositoryManifestGraph .
</pre>

In this example:
- `dcatr:usePrimaryAsDefault` is set to `true`, enforcing that the primary graph (`ex:molecules`) serves as the default graph.
- `ex:molecules` has a `dcatr:localGraphName` that differs from its canonical URI, enabling the service to address it under the name `<https://data.example.org/graphs/molecules>` in its local RDF dataset. Note that the graph naming statements are in the service manifest, while the graph type declaration (`dcatr:DataGraph`) is in the repository manifest.
- The `ServiceData` uses a blank node (`_:local`) since it does not need a globally stable identifier.
- Working graphs (`ex:staging`) and local system graphs (`ex:queryCache`) are in the service data, not in the repository.


### Service Extension Pattern

DCAT-R is designed to be extended by applications that define specialized service types. The following example sketches how a versioning service might extend the vocabulary with its own service type and system graph.

<pre class="example" title="Extending DCAT-R with a versioning service">
@prefix dcatr: &lt;https://w3id.org/dcatr#&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .
@prefix rdfs:  &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix owl:   &lt;http://www.w3.org/2002/07/owl#&gt; .
@prefix og: &lt;https://ontogen.io/ns/ontogen#&gt; .
@prefix ex: &lt;https://example.org/chem/&gt; .

# --- Vocabulary extension (defined by the application) ---

og:Service a owl:Class ;
    rdfs:subClassOf dcatr:Service ;
    rdfs:label "Versioning Service" ;
    rdfs:comment "A service providing version control operations over an RDF repository." .

og:HistoryGraph a owl:Class ;
    rdfs:subClassOf dcatr:SystemGraph ;
    rdfs:label "History Graph" ;
    rdfs:comment "System graph storing version history, commits, and provenance." .

og:repositoryHistory a owl:ObjectProperty ;
    rdfs:subPropertyOf dcatr:repositorySystemGraph ;
    rdfs:domain dcatr:Repository ;
    rdfs:range og:HistoryGraph ;
    rdfs:label "repository history" .

# --- Service manifest graph ---

ex:service a og:Service ;
    dcterms:title "Versioned Chemistry Repository" ;
    dcatr:serviceRepository ex:repository .

# --- Repository manifest graph ---

ex:repository a dcatr:Repository ;
    dcterms:title "Chemistry Research Repository" ;
    dcatr:repositoryDataset ex:dataset ;
    dcatr:repositoryManifestGraph ex:repository-manifest ;
    og:repositoryHistory ex:history .

ex:history a og:HistoryGraph ;
    dcterms:title "Version History" ;
    dcterms:description "Commit log and provenance for all dataset changes" .

ex:dataset a dcatr:Dataset ;
    dcatr:dataGraph ex:molecules .

ex:molecules a dcatr:DataGraph ;
    dcterms:title "Core Molecular Database" .

ex:repository-manifest a dcatr:RepositoryManifestGraph .
</pre>

This example demonstrates the extension pattern:
- `og:Service` is defined as a subclass of `dcatr:Service`, inheriting all DCAT-R structure.
- `og:HistoryGraph` is a specialized `dcatr:SystemGraph` for storing version history.
- `og:repositoryHistory` is a sub-property of `dcatr:repositorySystemGraph`, which means the history graph is automatically a `dcatr:member` of the repository (through the sub-property chain).
- The instance data uses the extended vocabulary alongside standard DCAT-R classes.

DCAT-R itself does not define the operations that a versioning service provides (commit, branch, merge, etc.) - it provides the structural vocabulary on which such operations are built.
