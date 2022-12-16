@IsTest
public class JsonEATest {
	static testMethod void testParse() {
		String json = '{'+
		'  \"action\": \"query\",'+
		'  \"responseId\": \"4Yqa2lR7EcEayu-qbxt9Z-\",'+
		'  \"results\": {'+
		'    \"metadata\": ['+
		'      {'+
		'        \"lineage\": {'+
		'          \"type\": \"foreach\",'+
		'          \"projections\": [{ \"field\": { \"id\": \"q.Account\", \"type\": \"numeric\" } }]'+
		'        }'+
		'      }'+
		'    ],'+
		'    \"records\": [{ \"Account\": 1622429 }]'+
		'  },'+
		'  \"query\": \"q = load \\\"0Fb1H000000MMWxSAO/0Fc1H0000027KtwSAE\\\";\\nq = group q by all;\\nq = foreach q generate count() as Account;\",'+
		'  \"responseTime\": 30'+
		'}';
		JSON2Apex r = JSON2Apex.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex.Field objField = new JSON2Apex.Field(System.JSON.createParser(json));
		System.assert(objField != null);
		System.assert(objField.id == null);
		System.assert(objField.type_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex objJSON2Apex = new JSON2Apex(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.action == null);
		System.assert(objJSON2Apex.responseId == null);
		System.assert(objJSON2Apex.results == null);
		System.assert(objJSON2Apex.query == null);
		System.assert(objJSON2Apex.responseTime == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex.Results objResults = new JSON2Apex.Results(System.JSON.createParser(json));
		System.assert(objResults != null);
		System.assert(objResults.metadata == null);
		System.assert(objResults.records == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex.Lineage objLineage = new JSON2Apex.Lineage(System.JSON.createParser(json));
		System.assert(objLineage != null);
		System.assert(objLineage.type_Z == null);
		System.assert(objLineage.projections == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex.Metadata objMetadata = new JSON2Apex.Metadata(System.JSON.createParser(json));
		System.assert(objMetadata != null);
		System.assert(objMetadata.lineage == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex.Projections objProjections = new JSON2Apex.Projections(System.JSON.createParser(json));
		System.assert(objProjections != null);
		System.assert(objProjections.field == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2Apex.Records objRecords = new JSON2Apex.Records(System.JSON.createParser(json));
		System.assert(objRecords != null);
		//System.assert(objRecords.Account == null);
	}
}