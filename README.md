belonesox.cocalc-on-fedora-ansible
=========
* Installs and configures a [Cocalc Hub](https://cocalc.com/)
   * install [Cocalc](https://github.com/sagemathinc/cocalc) on Fedora (FC34/FC35).

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: all
  gather_facts: True
  become: yes
  roles:
    - role: common-root
    - role: belonesox.cocalc-on-fedora-ansible
      cocalc_git_url: "https://github.com/belonesox/cocalc.git"
      cocalc_git_version: "master"
      dbname:  smc
      servername: 'calc'
      basedir: "/var/www/cocalc/"
      cocalc_dns: "cocalc.local.com"
      cocalc_site_name: 'Our CoCalc' 
      cocalc_site_description: '🖩0❌1⚖️📊' 
      cocalc_admin_email: 'stas-fomin@yandex.ru'
      cocalc_admin_first_name: 'Stas'
      cocalc_admin_last_name: 'Fomin'
      postgres_smc_pass: "pass17294815162342"
```

License
-------

MIT

Author Information
------------------

Stas Fomin <stas-fomin@yandex.ru>


Why?
-----------
* Yes, there exists https://github.com/sagemathinc/cocalc-docker based on Ubuntu.
* May be you did not like Ubuntu and prefer Fedora, because of
  * Reliable SAT-based dnf
  * Or what to use some packages existing specifically on RPM world.
  * Your target server or your desktop already on Fedora (or both) and you did not what to use 30GB docker blobs, and what to share large cocalc dependencies (TeXLive, etc) between several services (MediaWiki, Overleaf, … ).
* You are tired with docker/podman, swarm/kubernetes/… hell, and want to use classic <tt>systemd</tt> orchestration.
  * Actually, I spent several weeks trying to fix regular crashed of «cocalc-docker» on podman, and failed.
* You want to share your postgresql server (with centralized backups) with other services.
* You want to fast experimenting cycle with updating packages, patching configs/code inplace without rebuilding/reinstalling large docker blob, or remapping container filesystem.
* You like old-school configuration management with Vagrant/Ansible.


Known problems comparing with official docker
-----
* Sage Workswheets not working (Sage Jupyter Notebook works)
* Have to hack [version check](https://github.com/belonesox/cocalc/commit/4e27b57870b841dbe1eb4eb654103141627f22a1), dont know why.
* Sometimes crashed (restarted by systemd). But got same crashes on cocalc-docker.


How to debug
---- 

Install all this, or only packages locally 

```
ansible-playbook cocalc-local.yml 
```

```yml
- hosts: localhost
  gather_facts: True
  become: yes
  roles:
    - role: belonesox.cocalc-on-fedora-ansible
```

Grab git version of cocacl.
Use ``launch.json`` like that

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            // "type": "pwa-node",
            // "program": "./src/packages/hub/run/hub.js",
            "type": "node-terminal",
            "console": "integratedTerminal",
            "command": "node ./src/packages/hub/run/hub.js --mode=single-user --next-server --proxy-server --websocket-server --hostname=0.0.0.0 ",
            "request": "launch",
            "name": "run hub single",
            "outFiles": [
                "${workspaceFolder}/**/dist/**/",
                "!**/node_modules/**"
            ],
            "skipFiles": [
                "<node_internals>/**"
            ],
            "env": {
                "PGUSER": "smc",
                "PGHOST": "127.0.0.1",
                "PROJECTS": "/data4tb/smc/[project_id]",    
                "DEBUG NODE_ENV" : "development",
                "COCALC_NO_IDLE_TIMEOUT": "yes",
            },
            "runtimeArgs": [
                "--max_old_space_size=8000",
                "--trace-warnings",
                // "--preserve-symlinks",
                "--enable-source-maps"
            ],
            "outputCapture": "std",
            "justMyCode": false
    },
    {
        // "type": "pwa-node",
        // "program": "./src/packages/hub/run/hub.js",
        "type": "node-terminal",
        "console": "integratedTerminal",
        "sudo": true,        
        "command": "node ./src/packages/hub/run/hub.js --mode=multi-user --next-server --proxy-server --websocket-server --hostname=0.0.0.0",
        "request": "launch",
        "name": "runmulti",
        "outFiles": [
            "${workspaceFolder}/**/dist/**/",
            "!**/node_modules/**"
        ],
        "skipFiles": [
            "<node_internals>/**"
        ],
        "env": {
            "PGUSER": "smc",
            "PGHOST": "127.0.0.1",
            "PROJECTS": "/data4tb/smc/[project_id]",    
            "DEBUG NODE_ENV" : "development",
            "COCALC_NO_IDLE_TIMEOUT": "yes",
        },
        "runtimeArgs": [
            "--max_old_space_size=8000",
            "--trace-warnings",
            // "--preserve-symlinks",
            "--enable-source-maps"
        ],
        "justMyCode": true
},
{
    "type": "node-terminal",
    "console": "integratedTerminal",
    "command": "node ./src/packages/hub/run/hub.js --mode=single-user --next-server --proxy-server --websocket-server --hostname=0.0.0.0 --mode=single-user",
    "request": "launch",
    "name": "runjs",
    "outFiles": [
        "${workspaceFolder}/**/dist/**/",
        "!**/node_modules/**"
    ],
    "skipFiles": [
        "<node_internals>/**"
    ],
    "env": {
        "PGUSER": "smc",
        "PGHOST": "127.0.0.1",
        "PROJECTS": "/data4tb/smc/[project_id]",    
        "DEBUG NODE_ENV" : "development",
        "COCALC_NO_IDLE_TIMEOUT": "yes",
    },
    "runtimeArgs": [
        "--max_old_space_size=8000",
        "--trace-warnings",
        "--enable-source-maps"
    ],
    "outputCapture": "std",
    "justMyCode": false
},

]
}
```

What I need to know
-----
* How to debug with VSCode all parts of hub (project agent)
  * How to run without project agent?
  * How to run project agent separately?


Road Map / Ideas to implement 
-----
* XPRA over cocalc proxy very laggy (comparing with pure XPRA on free TCP port), absolutely unusable collaboration with text editing
* Something wrong with Hotkeys on Firefox («CTRL-SHIFT + -», «CTRL + ;» not working)
* Something about collaboration with coq (coq support on cocalc-notebooks)
* Something about collaboration with lean/idris/agda
* RISE support (may be switch to classic and run slides  will be OK)
* OAuth authorization over MediaWiki
* Add colaborative spreadsheet support (pyspread?, Colabora Libreoffice?)