#!/usr/bin/env python3
# ================================================
# RedSparrow v2.0.0 - Python Package Setup
# ================================================

from setuptools import setup, find_packages
import os
import sys

def read_file(filename):
    """Read a file and return its contents."""
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        return ""

def get_version():
    """Get version from module."""
    with open('red_sparrow.py', 'r', encoding='utf-8') as f:
        for line in f:
            if line.startswith('__version__'):
                return line.split('=')[1].strip().strip('"\'')

def get_requirements():
    """Get requirements from requirements.txt."""
    try:
        with open('requirements.txt', 'r') as f:
            return [line.strip() for line in f if line.strip() and not line.startswith('#')]
    except FileNotFoundError:
        return []

setup(
    name='red-sparrow',
    version=get_version() or '2.0.0',
    author='Ian Carter Kulani',
    author_email='ian@redsparrow.local',
    description='Ultimate Multi-Platform Phishing & Command Center',
    long_description=read_file('README.md'),
    long_description_content_type='text/markdown',
    url='https://github.com/redsparrow/red-sparrow',
    packages=find_packages(exclude=['tests', 'docs']),
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Information Technology',
        'Intended Audience :: System Administrators',
        'Topic :: Security',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: System :: Networking',
        'Topic :: System :: Systems Administration',
        'License :: Other/Proprietary License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
        'Operating System :: OS Independent',
    ],
    keywords=(
        'security, penetration-testing, phishing, nmap, nikto,'
        'ssh, traffic-generation, spoofing, discord-bot, telegram-bot'
    ),
    python_requires='>=3.7',
    install_requires=get_requirements(),
    extras_require={
        'dev': [
            'pytest>=7.4.0',
            'pytest-cov>=4.1.0',
            'pytest-asyncio>=0.21.0',
            'black>=23.7.0',
            'flake8>=6.1.0',
            'mypy>=1.5.0',
            'pylint>=2.17.0',
            'bandit>=1.7.5',
            'isort>=5.12.0',
            'sphinx>=7.1.0',
        ],
        'docs': [
            'sphinx>=7.1.0',
            'sphinx-rtd-theme>=1.3.0',
            'sphinx-autodoc-typehints>=1.24.0',
        ],
        'test': [
            'pytest>=7.4.0',
            'pytest-cov>=4.1.0',
            'pytest-asyncio>=0.21.0',
            'pytest-mock>=3.11.0',
            'pytest-xdist>=3.3.0',
        ],
    },
    entry_points={
        'console_scripts': [
            'redsparrow=red_sparrow:main',
            'red-sparrow=red_sparrow:main',
        ],
    },
    package_data={
        'redsparrow': [
            'templates/*.html',
            'static/*.css',
            'static/*.js',
            'config/*.json',
        ],
    },
    include_package_data=True,
    zip_safe=False,
)