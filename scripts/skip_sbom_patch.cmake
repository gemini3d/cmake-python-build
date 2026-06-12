if(NOT DEFINED SBOM_FILE)
  message(FATAL_ERROR "SBOM_FILE is required")
endif()

file(READ "${SBOM_FILE}" sbom_contents)

set(skip_marker "if os.environ.get(\"PYTHON_SBOM_SKIP\"):")
if(sbom_contents MATCHES "${skip_marker}")
  return()
endif()

set(old_line "CPYTHON_ROOT_DIR = Path(__file__).parent.parent.parent\n")
set(new_line "CPYTHON_ROOT_DIR = Path(__file__).parent.parent.parent\n\nif os.environ.get(\"PYTHON_SBOM_SKIP\"):\n    print(\"Skipping SBOM generation due to PYTHON_SBOM_SKIP\")\n    sys.exit(0)\n")

string(REPLACE "${old_line}" "${new_line}" sbom_contents "${sbom_contents}")

file(WRITE "${SBOM_FILE}" "${sbom_contents}")
