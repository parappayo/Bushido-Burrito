
#pragma once

#ifndef __INSTANCE_HELPERS_H__
#define __INSTANCE_HELPERS_H__

namespace BushidoBurrito
{

//------------------------------------------------------------------------------
template <class T> class StaticInstance
{
public:
	static T& get() { return m_instance; }

private:
	static T m_instance;
};
template <class T> T StaticInstance<T>::m_instance;

//------------------------------------------------------------------------------
template <class T> class LazyInstance
{
public:
	~LazyInstance()
	{
		if (m_instance == this) { m_instance = NULL; }
	}

	static T* get()
	{
		if (m_instance) { return m_instance; }
		m_instance = new T();
		return m_instance;
	}

private:
	static T* m_instance;
};
template <class T> T* LazyInstance<T>::m_instance = NULL;

//------------------------------------------------------------------------------
template <class T> class CustomInstance
{
	~CustomInstance()
	{
		if (m_instance == this) { m_instance = NULL; }
	}

	static T* get()
	{
		return m_instance;
	}

	static void init()
	{
		if (m_instance) { delete m_instance; }
		m_instance = new T();
	}

private:
	static T* m_instance;
};
template <class T> T* CustomInstance<T>::m_instance = NULL;

} // namespace BushidoBurrito

#endif // __INSTANCE_HELPERS_H__

