
#include "group.h"

#include "mex.h"
#include "matrix.h"

#define NAME "group"

using namespace std;


const char* mexFunctionName(){
    return NAME;
}

inline bool incr( mwIndex idx[], mwSize ndims, mwSize* dims, mwSize dim ){
    mwSize i;
    for( i = 0 ; i < ndims ; ++i ){
        if( i != dim ){
            ++idx[i];
            if( idx[i] >= dims[i] ){
                if( i == ndims - 1 ){
                    return false;
                }
                idx[i] = 0;
            }else{
                break;
            }
        }
    }
    return true;
}

inline vector<double> asVector( const mxArray* matrix, mwSize ndims, mwSize* dims, mwSize dim, mwIndex dimI ){
    vector<double> v;
    double* data = mxGetPr( matrix );
    mwSize N = dims[dim];
    mwIndex idx[ndims];
    for( mwSize i = 0 ; i < ndims ; ++i ){
        if( i == dim ){
            idx[i] = dimI;
        }else{
            idx[i] = 0;
        }
    }

    do{
        mwIndex si = mxCalcSingleSubscript( matrix, ndims, idx );
        v.push_back( data[si] );
    }while( incr( idx, ndims, dims, dim ) );
    return v;
}

inline vector< vector< double > > asVectors( const mxArray* matrix, mwSize ndims, mwSize* dims, mwSize dim ){
    vector< vector< double > > v;
    mwSize N = dims[dim];
    for( mwIndex i = 0 ; i < N ; ++i ){
        v.push_back( asVector( matrix, ndims, dims, dim, i ) );
    }
    return v;
}

void mexFunction( int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[] ){

    if( nrhs < 1 ){
        mexErrMsgIdAndTxt( "mgroup:nrhs", "At least one input required." );
    }

    if( nlhs != 1 ){
        mexErrMsgIdAndTxt( "mgroup:nlhs", "One output required." );
    }

    mwSize dim = 0;

    if( nrhs >= 2 ){
        //a dimension over which to group was specified
        const mxArray* dimArg = prhs[1];
        mxClassID type = mxGetClassID( dimArg );
        if( type != mxINT8_CLASS || type != mxUINT8_CLASS
            || type != mxINT16_CLASS || type != mxUINT16_CLASS
            || type != mxINT32_CLASS || type != mxUINT32_CLASS
            || type != mxINT64_CLASS || type != mxUINT64_CLASS
            || mxGetNumberOfElements( dimArg ) != 1){
            mexErrMsgIdAndTxt( "mgroup:dimension", "Dimension must be integer scalar" );
        }
        dim = (mwSize) mxGetScalar( dimArg ) - 1;
    }

    mxArray* arg = prhs[0];
    mwSize argNDims = mxGetNumberOfDimensions( arg );

    if( dim >= argNDims ){
        mexErrMsgIdAndTxt( "mgroup:dimension", "Matrix dimensions must be <= specified dim" );
    }

    const mwSize* argDims = mxGetDimensions( arg );

    if( mxIsCell( arg ) ){
        if( dim != 1 ){
            mexErrMsgIdAndTxt( "mgroup:dimension", "Dim must be 1 for cell array" );
        }
        size_t N = mxGetNumberOfElements( arg );
    }

    if( mxIsDouble( arg ) ){
        vector< vector< double > > vec = asVectors( arg, argNDims, argDims, dim );
        vector< vector< unsigned long > > indices = groupIndices( vec.begin(), vec.end() );
        plhs[0] = mxCreateCellArray( 1, mwSize[]{ indices.size() } );
        for( mwIndex i = 0 ; i < indices.size() ; ++i ){
            vector< unsigned long > idx = indices[i];
            UINT64_T* allocated = (UINT64_T*) mxCalloc( idx.size() , sizeof( *allocated ) );
            for( mwSize j = 0 ; i < idx.size() ; ++j ){
                allocated[j] = idx[j];
            }
            mxArray* row = mxCreateNumericMatrix( idx.size(), 1, mxUINT64_CLASS, mxREAL );
            mxSetData( row, allocated );
            mxSetCell( plhs[0], i, row );
        }
    }

}
