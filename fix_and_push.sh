#!/bin/bash
bash fix_project.sh
echo "⬆️ جاري الرفع التلقائي للنسخة المصلحة..."
git add .
git commit -m "Auto-fix: Synchronized clean build"
git push origin main
