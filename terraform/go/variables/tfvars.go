package variables

import (
	"fmt"
	"os"
	"strings"
)

func TFVars(dir, environment string) (map[string]string, []string, error) {

	varFiles, err := Parents(dir, ".+\\.tfvars$")
	if err != nil {
		return nil, nil, fmt.Errorf("Error getting var files %s", err.Error())
	}

	varFiles = filter(varFiles, func(f string) bool {
		return shouldInclude(environment, f)
	})

	defaultFiles, err := Parents(dir, ".+\\.tf$")
	if err != nil {
		return nil, nil, fmt.Errorf("Error getting default vars %s", err.Error())
	}

	defaults, err := ParseTerraformFiles(defaultFiles...)
	if err != nil {
		return nil, nil, fmt.Errorf("Error parsing tf files %s", err.Error())
	}

	vars, err := ParseVarFiles(varFiles...)
	if err != nil {
		return nil, nil, fmt.Errorf("Error parsing varfiles %s", err.Error())
	}

	envs := ImportEnvironmentVariables()
	for k, v := range envs {
		defaults[k] = v
	}

	for k, v := range vars {
		defaults[k] = v
	}

	ExportEnvironmentVariables(defaults)

	return defaults, varFiles, nil
}

func shouldInclude(env, af string) bool {
	paths := strings.Split(af, string(os.PathSeparator))
	f := paths[len(paths)-1]

	if strings.Contains(f, strings.ToLower(env)) && strings.HasSuffix(f, ".tfvars") {
		return true
	}

	return f == "global.tfvars" || f == "terraform.tfvars" || f == "private.tfvars"
}

func filter(files []string, include func(string) bool) []string {
	ret := make([]string, 0)
	for _, f := range files {
		if include(f) {
			ret = append(ret, f)
		}
	}
	return ret
}
