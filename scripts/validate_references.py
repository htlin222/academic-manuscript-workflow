#!/usr/bin/env python3
"""
Validate DOIs and URLs from BibTeX references.
This script checks if DOIs resolve correctly and URLs return valid responses.
Results are logged to log.txt with timestamps.

Usage: uv run validate_references.py
"""

import re
import sys
import time
from datetime import datetime
from pathlib import Path

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry


def setup_session():
    """Set up a requests session with retry strategy."""
    session = requests.Session()

    retry_strategy = Retry(
        total=3,
        backoff_factor=1,
        status_forcelist=[429, 500, 502, 503, 504],
    )

    adapter = HTTPAdapter(max_retries=retry_strategy)
    session.mount("http://", adapter)
    session.mount("https://", adapter)

    # Set user agent to avoid blocking
    session.headers.update(
        {"User-Agent": "Mozilla/5.0 (compatible; Reference Validator/1.0)"}
    )

    return session


def parse_bib_file(file_path):
    """Parse BibTeX file and extract DOIs and URLs."""
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Extract entry keys (citation keys)
    entry_pattern = r"@\w+\{([^,]+),"
    entries = re.findall(entry_pattern, content)

    # Extract DOIs
    doi_pattern = r"doi\s*=\s*\{([^}]+)\}"
    dois = re.findall(doi_pattern, content)

    # Extract URLs
    url_pattern = r"url\s*=\s*\{([^}]+)\}"
    urls = re.findall(url_pattern, content)

    return entries, dois, urls


def validate_doi(session, doi):
    """Validate a DOI by checking if it resolves."""
    if not doi:
        return False, "Empty DOI"

    # Clean DOI
    doi = doi.strip()
    doi_url = f"https://doi.org/{doi}"

    try:
        response = session.head(doi_url, timeout=30, allow_redirects=True)
        if response.status_code == 200:
            return True, f"DOI resolves correctly (status: {response.status_code})"
        else:
            return False, f"DOI failed with status: {response.status_code}"
    except requests.exceptions.Timeout:
        return False, "DOI validation timed out"
    except requests.exceptions.ConnectionError:
        return False, "DOI connection error"
    except Exception as e:
        return False, f"DOI validation error: {str(e)}"


def validate_url(session, url):
    """Validate a URL by checking if it returns a valid response."""
    if not url:
        return False, "Empty URL"

    # Clean URL
    url = url.strip()

    try:
        response = session.head(url, timeout=30, allow_redirects=True)
        if response.status_code == 200:
            return True, f"URL accessible (status: {response.status_code})"
        else:
            return False, f"URL failed with status: {response.status_code}"
    except requests.exceptions.Timeout:
        return False, "URL validation timed out"
    except requests.exceptions.ConnectionError:
        return False, "URL connection error"
    except Exception as e:
        return False, f"URL validation error: {str(e)}"


def log_result(log_file, message):
    """Log a message with timestamp."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"[{timestamp}] {message}\n"

    with open(log_file, "a", encoding="utf-8") as f:
        f.write(log_entry)

    print(log_entry.strip())


def main():
    """Main validation function."""
    bib_file = Path("../reference.bib")
    log_file = Path("log.txt")

    # Clear previous log
    if log_file.exists():
        log_file.unlink()

    log_result(log_file, "=== Reference Validation Started ===")

    if not bib_file.exists():
        log_result(log_file, "ERROR: reference.bib not found")
        sys.exit(1)

    try:
        entries, dois, urls = parse_bib_file(bib_file)
        log_result(
            log_file,
            f"Found {len(entries)} entries, {len(dois)} DOIs, {len(urls)} URLs",
        )

        session = setup_session()

        # Validate DOIs
        log_result(log_file, "\n--- Validating DOIs ---")
        doi_success = 0
        for i, doi in enumerate(dois, 1):
            log_result(log_file, f"Validating DOI {i}/{len(dois)}: {doi}")
            success, message = validate_doi(session, doi)

            if success:
                doi_success += 1
                log_result(log_file, f"✅ {message}")
            else:
                log_result(log_file, f"❌ {message}")

            # Rate limiting
            time.sleep(0.5)

        # Validate URLs
        log_result(log_file, "\n--- Validating URLs ---")
        url_success = 0
        for i, url in enumerate(urls, 1):
            log_result(log_file, f"Validating URL {i}/{len(urls)}: {url[:80]}...")
            success, message = validate_url(session, url)

            if success:
                url_success += 1
                log_result(log_file, f"✅ {message}")
            else:
                log_result(log_file, f"❌ {message}")

            # Rate limiting
            time.sleep(0.5)

        # Summary
        log_result(log_file, "\n=== Validation Summary ===")
        log_result(log_file, f"DOIs: {doi_success}/{len(dois)} successful")
        log_result(log_file, f"URLs: {url_success}/{len(urls)} successful")
        log_result(
            log_file,
            f"Total: {doi_success + url_success}/{len(dois) + len(urls)} successful",
        )

        if doi_success == len(dois) and url_success == len(urls):
            log_result(log_file, "🎉 All references validated successfully!")
        else:
            log_result(
                log_file,
                "⚠️  Some references failed validation - review log for details",
            )

    except Exception as e:
        log_result(log_file, f"ERROR: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
