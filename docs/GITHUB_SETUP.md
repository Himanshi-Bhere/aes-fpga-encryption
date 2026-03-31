# GitHub Upload Guide

## Step 1: Create Repository on GitHub

1. Go to https://github.com/new
2. Fill in:
   - Repository name: `aes-fpga-encryption` (or your preferred name)
   - Description: `AES-128 FPGA Encryption System with Tests`
   - Choose Public or Private
3. **IMPORTANT:** Do NOT initialize with README, .gitignore, or license
4. Click "Create Repository"

## Step 2: Get Your Repository URL

After creating, you'll see:
```
https://github.com/YOUR-USERNAME/aes-fpga-encryption.git
```

(Replace YOUR-USERNAME with your actual GitHub username)

## Step 3: Push Your Code

Run these commands in PowerShell from your project directory:

```bash
cd c:\fpga\project

# Add remote (replace with your URL from Step 2)
git remote add origin https://github.com/YOUR-USERNAME/aes-fpga-encryption.git

# Rename branch to main
git branch -M main

# Push code to GitHub
git push -u origin main
```

## Step 4: Verify Upload

Go to https://github.com/YOUR-USERNAME/aes-fpga-encryption

You should see:
- src/ folder with 7 Verilog files
- tests/ folder with 3 testbenches
- docs/ folder with guides
- README.md
- .gitignore and .gitattributes

## What Gets Uploaded

**Uploaded (15 files):**
- All source code (src/)
- All test files (tests/)
- All documentation (docs/)
- README.md
- .gitignore
- .gitattributes

**NOT Uploaded (excluded by .gitignore):**
- .venv/ (Python environment)
- *.vvp (compiled simulation files - can regenerate)
- *.vcd (waveform files - can regenerate)
- __pycache__
- .vscode/
- Other temporary files

This keeps your repository small and clean!

## After Upload

To make updates later:

```bash
# Make changes to files
# Then:
git add .
git commit -m "Your message describing changes"
git push origin main
```

## Questions?

- Check GitHub's help: https://docs.github.com
- SSH vs HTTPS: Use HTTPS unless you have SSH keys set up
- Private repo: Only you can see it. Public: Everyone can see it.

## Next Steps

After uploading, you can:
1. Share the link with your instructor
2. Show them the code organization
3. Link from your portfolio
4. Collaborate with others (if not private)
