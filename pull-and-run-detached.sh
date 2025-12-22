#!/bin/bash
git pull && docker compose --env-file whitelist.env up -d