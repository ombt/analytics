// matrix transformation functions
template <class T>
int
transpose(Matrix &m)
{
	// create transpose matrix
	Matrix tmp(m.ncols, m.nrows);

	// transpose element and copy
	for (int ir = 0; ir < m.nrows; ir++)
	{
		for (int ic = 0; ic < m.ncols; ic++)
		{
			tmp(ic, ir) = m(ir, ic);
		}
	}
	m = tmp;

	// all done
	return(OK);
}

template <class T>
int
conjugate(Matrix &m)
{
	// conjugate element and copy
	for (int ir = 0; ir < m.nrows; ir++)
	{
		for (int ic = 0; ic < m.ncols; ic++)
		{
			m(ic, ir) = conj(m(ir, ic));
		}
	}

	// all done
	return(OK);
}

template <class T>
int
inverse(Matrix &m, T epsilon)
{
	// check dimensions
	MusBeTrue((m.nrows == m.ncols) && (m.nrows > 0));
	epsilon = local_abs(epsilon);

	// set loop limit
	int nd = m.nrows;

	// create augmented matrix and initialize
	Matrix augm(m.nrows, 2*m.ncols);
	for (int ir = 0; ir < m.nrows; ir++)
	{
		for (int ic = 0; ic < m.ncols; ic++)
		{
			augm(ir, ic) = m(ir, ic);
		}
		augm(ir, m.ncols+ir) = 1.0;
	}

	// implement a gaussian elimination with partial pivoting
	for (int id = 0; id < nd; id++)
	{
		// find maximum element in column
		T maxv = abs(m(id, id));
		int maxir = id;
		for (int ir = id+1; ir < m.nrows; ir++)
		{
			if (abs(augm(ir, id)) > maxv)
			{
				maxv = abs(augm(ir, id));
				maxir = ir;
			}
		}

		// check maximum value in column for singularity
		if (maxv <= epsilon)
		{
			// matrix is or is almost singular
			ERRORD("matrix is singular", maxv, EINVAL);
			return(NOTOK);
		}

		// swap rows
		if (maxir != id)
		{
			// swap matrix rows and vector values
			for (int ic = id; ic < 2*m.ncols; ic++)
			{
				maxv = augm(maxir, ic);
				augm(maxir, ic) = augm(id, ic);
				augm(id, ic) = maxv;
			}
		}

		// do gaussian elimination for other rows and columns
		for (ir = 0; ir < m.nrows; ir++)
		{
			if (ir != id)
			{
				T scale = augm(ir, id)/augm(id, id);
				for (int ic = id; ic < 2*m.ncols; ic++)
				{
					augm(ir, ic) -= scale*augm(id, ic);
				}
			}
			else
			{
				T scale = 1.0/augm(id, id);
				for (int ic = id; ic < 2*m.ncols; ic++)
				{
					augm(ir, ic) *= scale;
				}
			}
		}
	}

	// store inverse in original matrix
	for (ir = 0; ir < m.nrows; ir++)
	{
		for (int ic = 0; ic < m.ncols; ic++)
		{
			m(ir, ic) = augm(ir, m.ncols+ic);
		}
	}

	// all done
	return(OK);
}

template <class T>
int
solve(Matrix &m, Vector<T> &x, Vector<T> &b, T epsilon)
{
	// check dimensions
	MustBeTrue(m.nrows == m.ncols);
	MustBetrue(x.getDimension() == b.getDimension());
	MustBeTrue(m.nrows == b.getDimension()) && (m.nrows > 0));
	epsilon = local_abs(epsilon);

	// set loop limit
	int nd = m.nrows;

	// implement a gaussian elimination with partial pivoting
	for (int id = 0; id < nd; id++)
	{
		// find maximum element in column
		T maxv = abs(m(id, id));
		int maxir = id;
		for (int ir = id+1; ir < m.nrows; ir++)
		{
			if (abs(m(ir, id)) > maxv)
			{
				maxv = abs(m(ir, id));
				maxir = ir;
			}
		}

		// check maximum value in column for singularity
		if (maxv <= epsilon)
		{
			// matrix is or is almost singular
			ERRORD("matrix is singular", maxv, EINVAL);
			return(NOTOK);
		}

		// swap rows
		if (maxir != id)
		{
			// swap matrix rows and vector values
			for (int ic = id; ic < m.ncols; ic++)
			{
				maxv = m(maxir, ic);
				m(maxir, ic) = m(id, ic);
				m(id, ic) = maxv;
			}
			T tmpb = b[maxir];
			b[maxir] = b[id];
			b[id] = tmpb;
		}

		// do gaussian elimination for other rows and columns
		for (ir = id+1; ir < m.nrows; ir++)
		{
			T scale = m(ir, id)/m(id, id);
			for (int ic = id; ic < m.ncols; ic++)
			{
				m(ir, ic) -= scale*m(id, ic);
			}
			b[ir] -= scale*b[id];
		}
	}

	// store inverse in original matrix
	for (int ir = m.nrows-1; ir >= 0; ir--)
	{
		x[ir] = b[ir];
		for (int ic = ir+1; ic < m.ncols; ic++)
		{
			x[ir] -= m(ir, ic)*x[ic];
		}
		x[ir] /= m(ir, ic);
	}

	// all done
	return(OK);
}

template <class T>
int
determinant(const Matrix &m, T &det, T epsilon)
{
	// check dimensions
	MustBeTrue((m.nrows == m.ncols) && (m.nrows > 0));
	epsilon = local_abs(epsilon);
	Matrix tmp(m);

	// set loop limit
	int nd = m.nrows;

	// implement a gaussian elimination with partial pivoting
	int nswaps = 0;
	for (int id = 0; id < nd; id++)
	{
		// find maximum element in column
		T maxv = abs(tmp(id, id));
		int maxir = id;
		for (int ir = id+1; ir < tmp.nrows; ir++)
		{
			if (abs(tmp(ir, id)) > maxv)
			{
				maxv = abs(tmp(ir, id));
				maxir = ir;
			}
		}

		// check maximum value in column for singularity
		if (maxv <= epsilon)
		{
			// matrix is or is almost singular
			ERRORD("matrix is singular", maxv, EINVAL);
			return(NOTOK);
		}

		// swap rows
		if (maxir != id)
		{
			// swap matrix rows and vector values
			for (int ic = id; ic < tmp.ncols; ic++)
			{
				maxv = tmp(maxir, ic);
				tmp(maxir, ic) = tmp(id, ic);
				tmp(id, ic) = maxv;
			}
			nswaps++;
		}

		// do gaussian elimination for other rows and columns
		for (ir = id+1; ir < tmp.nrows; ir++)
		{
			T scale = tmp(ir, id)/tmp(id, id);
			for (int ic = id; ic < tmp.ncols; ic++)
			{
				tmp(ir, ic) -= scale*tmp(id, ic);
			}
		}
	}

	// store inverse in original matrix
	for (id = 1, det = tmp(0, 0); id < tmp.nrows; id++)
	{
		det += tmp(id, id);
	}
	if (nswaps%2 != 0) det *= -1.0;

	// all done
	return(OK);
}

template <class T>
int
trace(const Matrix &m, T &tr)
{
	// matrix should be square
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// add up diagonal elements
	tr = 0.0;
	for (int id = 0; id < m.nrows; id++)
	{
		tr += m(id, id);
	}

	// all done
	return(OK);
}
