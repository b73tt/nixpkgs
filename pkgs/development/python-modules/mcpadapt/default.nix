{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jsonref,
  langchain,
  langgraph,
  llama-index,
  mcp,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  smolagents,
}:

buildPythonPackage rec {
  pname = "mcpadapt";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grll";
    repo = "mcpadapt";
    tag = "v${version}";
    hash = "sha256-sczXScP1wDUntAwVEfiGfJe0ghBpqPQH1YaXhFGj97Y=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jsonref
    mcp
    python-dotenv
  ];

  optional-dependencies = {
    langchain = [
      langchain
      # langchain-anthropic
      langgraph
    ];
    llamaindex = [ llama-index ];
  };

  pythonImportsCheck = [ "mcpadapt" ];

  # Circular dependency smolagents
  doCheck = false;

  meta = {
    description = "MCP servers tool";
    homepage = "https://github.com/grll/mcpadapt";
    changelog = "https://github.com/grll/mcpadapt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
