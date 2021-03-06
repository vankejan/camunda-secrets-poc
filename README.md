# Camunda & Docker Secrets

Example taken from [this repository](https://github.com/DigitalState/camunda-variations/tree/master/docker-secrets).

To use this example without Docker Swarm just enable Buildkit.

Adjusted to be used with KosAPI service.

The `processes` folder contains Camunda process example usage.

Also there is a [Dockerfile](https://github.com/vankejan/camunda-secrets-poc/blob/main/Dockerfile) for Camunda.

To run this, you to authenticate docker against `registry.gitlab.fel.cvut.cz/czm/camunda/camunda_services/kosapi-service` then run `docker-compose up -d`

In `tokens.json` file you need to set correct URL and port of KosAPI service instance. 

### Usage in Camunda process

Add a script task with javascript (either inline or external):

```
 * Load Passwords Json File and returns a specific password
 *
 * @param string key The json property key that the password is stored. Currently only single level json is supported.
 * @param string secretsEnv The Env Variable name that the JSON is stored in using Docker Secrets
 * @return string The password. Assumes that all passwords are strings and therefore returns a string.
 */
function getSecret(key, secretsEnv) // if needed, this function can contain OAuth autentication. 
{
  with (new JavaImporter(java.lang.System, java.nio.file))
  {
    var secretsPath = System.getenv(secretsEnv)
    var secretsFileBytes = Files.readAllBytes(Paths.get(secretsPath))
  }

  var String = Java.type('java.lang.String')
  var secretsFileString = new String(secretsFileBytes)

  var secretsJson = JSON.parse(secretsFileString)
  var secret = secretsJson[key]

  return secret.toString()
}

var token = getSecret('token', 'CAMUNDA_TOKENS_FILE') // get token
var url = getSecret('url', 'CAMUNDA_TOKENS_FILE') // get url

with (new JavaImporter(org.jsoup))
{

  var doc =  Jsoup.connect(url + '/students/vankejan/theses/?token=' + token)
                  .ignoreContentType(true)
                  .method(Java.type('org.jsoup.Connection.Method').GET)
                  .timeout(30000)
                  .execute()

  var resBody = doc.body()
}

function spinify(body)
{
  var parsed = JSON.parse(body)
  var stringified = JSON.stringify(parsed)
  var spin = S(stringified)
  return spin
}

execution.setVariable('responseBodyString', spinify(resBody))
```


## ORIGINAL DOCS 

This deploys Camunda along with a Docker Secrets volume for the my_password.json file.
Allows you to securely access Secrets without storing them in a Camunda Process Variable

https://docs.docker.com/engine/swarm/secrets

https://forum.camunda.org/t/using-secrets-passwords-securely-in-processes-using-docker-secrets-not-storing-passwords-in-process-variables
