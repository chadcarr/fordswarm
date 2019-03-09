#@IgnoreInspection BashAddShebang
if [[ -z ${CHEF_POLICYFILE+x} ]]; then
  policy_name="base"
else
  policy_name=${CHEF_POLICYFILE}
fi

scaffold_policy_name="$policy_name"
pkg_name=chef-base
pkg_origin=chadcarr
pkg_version="0.1.1"
pkg_maintainer="Chad Carr <ccarr@franzdoodle.com>"
pkg_description="The Chef $scaffold_policy_name Policy"
pkg_upstream_url="http://chef.io"
pkg_scaffolding="core/scaffolding-chef"
pkg_svc_user=("root")