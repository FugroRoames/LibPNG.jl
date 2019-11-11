using BinaryProvider # requires BinaryProvider 0.3.0 or later


function compile(libname, tarball_url, hash; prefix=BinaryProvider.global_prefix, verbose=false)
    # download to tarball_path
    tarball_path = joinpath(prefix, "downloads", libname)
    download_verify(tarball_url, hash, tarball_path; force=true, verbose=verbose)

    # unpack into source_path
    tarball_dir = joinpath(prefix, "downloads", dirname(first(list_tarball_files(tarball_path))))
    source_path = joinpath(prefix, "downloads", "src")
    verbose && @info("Unpacking $tarball_path into $source_path")
    rm(tarball_dir, force=true, recursive=true)
    rm(source_path, force=true, recursive=true)
    unpack(tarball_path, dirname(tarball_dir); verbose=verbose)
    mv(tarball_dir, source_path)

    # install libpng
    build_dir = joinpath(source_path, "build")
    mkdir(build_dir)
    verbose && @info("Compiling in $build_dir...")
    cd(build_dir) do
        # build in parallel hdf5 mode if mpi is installed
        mkpath(libdir(prefix))
        run(`$cmake_executable .. -DCMAKE_INSTALL_PREFIX=$(prefix.path)`)
        run(`make -j $(Sys.CPU_THREADS + 1)`)
        run(`make install -j $(Sys.CPU_THREADS + 1)`)
    end

    # remove old files if force=true
    manifest_path = manifest_from_url(tarball_url, prefix=prefix)
    isfile(manifest_path) && rm(manifest_path, force=true, recursive=true)

    # First, get list of files that are contained within the tarball
    file_list = list_tarball_files(tarball_path, verbose=true)

    # Save installation manifest
    mkpath(dirname(manifest_path))
    open(manifest_path, "w") do f
        for (i, path) in enumerate(file_list)
            file_list[i] = replace(file_list[i], dirname(first(list_tarball_files(tarball_path))) => "downloads/src" )
        end
        write(f, join(file_list, "\n"))
    end
end
