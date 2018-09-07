#!/usr/bin/python
'''
Script to run the irt on images.
'''
import optparse
import os

from pyirt import irt,utils

def _options_to_parameter_dict(options):
    '''
    Convert the options object into a parameter dictionary, the format used in
    this module to initialise IRTs.
    '''
    params = {}
    params.update(irt.standard_parameters) #main defaults
    if options.param_file is not None:            
        file_params = irt.parameter_file_to_dict(options.param_file)
        params.update(file_params) #our file parameters which override the defaults
    #the rest of our parameters, which override the defined parameters
    if options.verbose is not None:
        params['verbose'] = options.verbose
    if options.out_dir is not None:
        params['out_dir'] = options.out_dir
    if options.param_out is not None:
        params['param_out'] = options.param_out
    if options.progress_images is not None:
        params['progress_images'] = options.progress_images
    if options.N is not None:
        params['N'] = options.N
    if options.step_size is not None:
        params['step_size'] = options.step_size
    if options.index_type is not None:
        params['index_type'] = options.index_type
    if options.refract_val is not None:
        params['refract_val'] = options.refract_val
    if options.diff_type is not None:
        params['diff_type'] = options.diff_type
    if options.max_depth is not None:
        params['max_depth'] = options.max_depth
    if options.max_length is not None:
        params['max_length'] = options.max_length
    if options.use_edges is not None:
        params['use_edges'] = options.use_edges
    if options.rms_cease is not None:
        params['rms_cease'] = options.rms_cease
    if options.target is not None:
        params['target'] = options.target
    if options.multiple_passes is not None:
        params['multiple_passes'] = options.multiple_passes
    if options.multiprocessing is not None:
        params['multiprocessing'] = options.multiprocessing
        
    return params

def _get_options():
    '''
    Process the command line options and arguments.
    '''
    usage = "usage: %prog [options] FILEDIR [FILEDIR ...]"
    version = "%prog 1.0"    
    epilog = "This program implements the image ray transform, for a more complete summary \
     of parameters please see the enclosed documentation."
    parser = optparse.OptionParser(usage=usage, version=version, epilog=epilog)
    
    parser.add_option("-v", "--verbose", action="store_true",dest="verbose",
                      help="verbose mode",)
    parser.add_option("-o", "--outdir", action="store",dest="out_dir", type="string",
                      help="Directory to output to", metavar="OUTDIR")
    parser.add_option("-p", "--paramfile", action="store",dest="param_file", type="string",
                      help="File defining the ray transform parameters.", metavar="PARAMFILE")
    parser.add_option("-P", "--paramout", action="store",dest="param_out", type="string",
                      help="Filename of file recording these parameters", metavar="PARAMOUT")
    parser.add_option("-i", "--progressim", action="store_true",dest="progress_images",
                      help="Output the state of the accumulators every STEPSIZE rays.")
    parser.add_option("-M", "--multiprocessing", action="store",dest="multiprocessing", type="int",
                  help="Use multiple processes. 0 sets to the number of cpus, if possible.", metavar="PROCESSES")
    
    parser.add_option("-N", "--maxrays", action="store",dest="N", type="int",
                      help="maximum number of rays to trace", metavar="MAXRAYS")
    parser.add_option("-s", "--stepsize", action="store",dest="step_size", type="int",
                      help="number of rays to trace at once", metavar="STEPSIZE")
    parser.add_option("-D", "--rmscease", action="store",dest="rms_cease", type="float",
                      help="Stopping condition", metavar="DS")
    
    parser.add_option("-n", "--linear","--nmax", action="store_const",dest="index_type", const="linear",
                      help="Use linear refractive indices: set n_max with -r")
    parser.add_option("-k", "--exponential", action="store_const",dest="index_type", const="exponential",
                      help="controls growth of exponential refractive indices")
    parser.add_option("-r", "--refractval", action="store",dest="refract_val", type="float",
                      help="Value of the parameter that controls refractive indices, selected by -n and -k", metavar="VAL")
    #perhaps hide these
    parser.add_option("--hightolow", action="store_const",dest="diff_type", const = 0,
                      help="Refraction policy: only high to low")
    parser.add_option("--lowtohigh", action="store_const",dest="diff_type", const = 1,
                      help="Refraction policy: only low to high")
    parser.add_option("--both", action="store_const",dest="diff_type", const = 2,
                      help="Refraction policy: always refract")
    
    parser.add_option("-d", "--maxdepth", action="store",dest="max_depth", type="int",
                  help="maximum depth for rays", metavar="MAXDEPTH")
    parser.add_option("-l", "--maxlength", action="store",dest="max_length", type="float",
                  help="maximum length of rays", metavar="MAXLENGTH")
    
    parser.add_option("-E", "--edges", action="store_true",dest="use_edges",
                  help="use edges rather than intensity", metavar="edges")
    parser.add_option("-t", "--target", action="store",dest="target", type="int",
                  help="set a target intensity", metavar="TARGET")
    parser.add_option("-m", "--multiple", action="store",dest="multiple_passes", type="int",
                  help="perform a number of transforms, and combine results", metavar="PASSES")
    

    (options, args) = parser.parse_args()
    if len(args) < 1:
        parser.error("No file or directory to process supplied")
    
    if options.param_file is not None and not os.path.exists(options.param_file):
        parser.error("-p Parameter file does not exist")        
        
    if options.N is not None and options.N <= 0:
        parser.error("-N (maximum number of rays) must be greater than 0")
    if options.step_size is not None and options.step_size <= 0:
        parser.error("-s (number of rays to do before checking things) must be greater than 0")
    if options.rms_cease is not None and options.rms_cease < 0:
        parser.error("-D (RMS difference to stop transform at) must be 0 or greater")
    if options.index_type is not None and options.index_type is "linear" and options.refract_val < 1:
        parser.error("-r Linear refract value must be 1 or greater")
    if options.index_type is not None and options.index_type is "exponential" and options.refract_val <= 0:
        parser.error("-r Exponential refract value must be greater than 0")
    if options.max_depth is not None and options.max_depth <= 0:
        parser.error("-d (maximum number of ray refractions/reflections or depth) must be greater than 0")
    if options.max_length is not None and options.max_length <= 0:
        parser.error("-l (maximum distance a ray is followed) must be greater than 0")
    if options.target is not None and (options.target < 0 or options.target > 255):
        parser.error("-t (target intensity) must be  0 or greater and less than or equal to 255")
    if options.multiple_passes is not None and (options.multiple_passes < 2 or options.multiple_passes > 255):
        parser.error("-m (number of transforms) must be  2 or greater and 255 or less")
    if options.multiprocessing is not None and options.multiprocessing < 0:
        parser.error("-M (number of processes) must be 0 or greater")
          
    return options,args

def expand_image_args(arglist):
    '''
    Turn any directories in *arglist* into an expanded form. Remove any 
    files that are not image files.
    '''
    file_list = []
    for arg in arglist:
        if os.path.isdir(arg):
            dirfiles = os.listdir(arg)
            for dirfile in dirfiles:
                name,ext = os.path.splitext(dirfile)
                if utils.is_image_ext(ext):
                    file_list.append(os.path.join(arg,dirfile))
        elif os.path.exists(arg):
            name,ext = os.path.splitext(arg)
            if utils.is_image_ext(ext):
                file_list.append(arg)
        else:
            raise IOError(arg + " does not exist.")
    return file_list
            
def main():
    options,args = _get_options()
    params = _options_to_parameter_dict(options)
    file_list = expand_image_args(args)
    if not os.path.exists(params['out_dir']):
        os.makedirs(params['out_dir'])
    irt.parameter_dict_to_file(params, os.path.join(params['out_dir'],params['param_out']))
    irt.do_transform_files(file_list, params)

if __name__ == '__main__':
    main()